import 'dart:async';

import 'package:camera/camera.dart' as camera;
import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show Ref, StateController, StateNotifier;
import 'package:lazy_camera/_features.dart';

abstract interface class CameraLogicInterface
    implements StateNotifier<CameraState> {
  Future<void> reset();
  ValueNotifier<camera.CameraValue> get controller;
  bool get isInitialized;
  Future<void> startImageStream();
  Future<void> onDispose();
}

final class CameraLogic extends StateNotifier<CameraState>
    implements CameraLogicInterface {
  CameraLogic(
    Ref ref, {
    CameraState? state,
  })  : _ref = ref,
        super(state ?? const CameraState.uninitialized()) {
    _setup();
  }

  final Ref _ref;
  camera.CameraDescription? _frontCamera;
  camera.CameraController? _controller;
  bool _isStreamingImages = false;

  StateController<AppException?> get _errorManager {
    return _ref.read(appExceptionRef.notifier);
  }

  set _error(AppException exception) {
    if (_errorManager.mounted) _errorManager.state = exception;
  }

  Future<void> _setup() async {
    final cameras = await _getAvailableCameras();
    _frontCamera = _getFirstFrontCamera(cameras);

    if (_frontCamera == null) return;

    await reset();
  }

  Future<List<camera.CameraDescription>> _getAvailableCameras() async {
    late List<camera.CameraDescription> cameras;

    try {
      cameras = await camera.availableCameras();
    } on camera.CameraException catch (e) {
      _error = AppException.fromCode(e.code);
      cameras = List<camera.CameraDescription>.empty();
    } catch (e) {
      _error = const AppException.unknown();
      cameras = List<camera.CameraDescription>.empty();
    }

    return cameras;
  }

  camera.CameraDescription? _getFirstFrontCamera(
    List<camera.CameraDescription> cameraDescriptions,
  ) {
    final frontCameraDescriptions = cameraDescriptions.where(
      (description) {
        return description.lensDirection == camera.CameraLensDirection.front;
      },
    );

    if (frontCameraDescriptions.isEmpty) {
      _error = const AppException.noFrontCamera();
    }

    return frontCameraDescriptions.firstOrNull;
  }

  camera.CameraController _getCameraController({
    required camera.CameraDescription cameraDescription,
    bool enableAudio = true,
  }) {
    return camera.CameraController(
      cameraDescription,
      camera.ResolutionPreset.max,
      enableAudio: enableAudio,
      //TODO: check the good format
      //imageFormatGroup: camera.ImageFormatGroup.jpeg,
    );
  }

  Future<void> _initialize(camera.CameraController controller) async {
    try {
      await controller.initialize();
    } on camera.CameraException catch (e) {
      _error = AppException.fromCode(e.code);
    } catch (e) {
      _error = const AppException.unknown();
    }
  }

  void _cameraListener() {
    if (mounted) {
      if (_controller?.value.hasError ?? false) {
        _error = AppException.playingCamera(
          message: controller.value.errorDescription ?? 'Unknown error',
        );
      }
    }
  }

  void _imageListener(camera.CameraImage cameraImage) {
    if (mounted && _controller != null && _isStreamingImages) {
      //TODO: convert cameraImage to bytes
      state = const CameraState.imageStream();
    }
  }

  @override
  Future<void> reset() async {
    state = const CameraState.uninitialized();
    await onDispose();

    if (_frontCamera == null) return;

    _controller = _getCameraController(
      cameraDescription: _frontCamera!,
    )..addListener(_cameraListener);

    await _initialize(_controller!);
    state = const CameraState.preview();
  }

  @override
  ValueNotifier<camera.CameraValue> get controller {
    return _controller as ValueNotifier<camera.CameraValue>;
  }

  @override
  bool get isInitialized => _controller?.value.isInitialized ?? false;

  @override
  Future<void> startImageStream() async {
    if ((_controller?.value.isInitialized ?? false) &&
        !_controller!.value.isStreamingImages) {
      _isStreamingImages = true;
      await _controller!.startImageStream(_imageListener);
    }
  }

  @override
  Future<void> onDispose() async {
    _isStreamingImages = false;
    if ((_controller?.value.isInitialized ?? false) &&
        _controller!.value.isStreamingImages) {
      await _controller?.stopImageStream();
    }
    _controller?.removeListener(_cameraListener);
    await _controller?.dispose();
    _controller = null;
  }
}
