import 'dart:async';

import 'package:camera/camera.dart' as camera;
import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show Ref, StateController, StateNotifier;
import 'package:image/image.dart' as img;
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
      // TODO: pass to isolate to manage images
      _isStreamingImages = false;

      final imageOrNull = switch (cameraImage.format.group) {
        camera.ImageFormatGroup.yuv420 => _convertYUV420ToImage(cameraImage),
        camera.ImageFormatGroup.bgra8888 =>
          _convertBGRA8888ToImage(cameraImage),
        _ => null,
      };

      final bytes = imageOrNull != null ? img.encodeJpg(imageOrNull) : null;
      state = CameraState.imageStream(
        bytes: bytes,
        sensorOrientation: _controller!.description.sensorOrientation,
      );
    }
  }

  /// Converts a [camera.CameraImage] in BGRA888 format to [img.Image] in RGB
  /// format.
  img.Image _convertBGRA8888ToImage(camera.CameraImage image) {
    final plane = image.planes.first;
    return img.Image.fromBytes(
      width: plane.width!,
      height: plane.height!,
      bytes: plane.bytes.buffer,
      order: img.ChannelOrder.bgra,
    );
  }

  /// Converts a [camera.CameraImage] in YUV420 format to [img.Image] in RGB
  /// format.
  img.Image _convertYUV420ToImage(camera.CameraImage cameraImage) {
    final imageWidth = cameraImage.width;
    final imageHeight = cameraImage.height;

    final yBuffer = cameraImage.planes[0].bytes;
    final uBuffer = cameraImage.planes[1].bytes;
    final vBuffer = cameraImage.planes[2].bytes;

    final int yRowStride = cameraImage.planes[0].bytesPerRow;
    final int yPixelStride = cameraImage.planes[0].bytesPerPixel!;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = img.Image(width: imageWidth, height: imageHeight);

    for (int h = 0; h < imageHeight; h++) {
      int uvh = (h / 2).floor();

      for (int w = 0; w < imageWidth; w++) {
        int uvw = (w / 2).floor();

        final yIndex = (h * yRowStride) + (w * yPixelStride);

        // Y plane should have positive values belonging to [0...255]
        final int y = yBuffer[yIndex];

        // U/V Values are sub-sampled i.e. each pixel in U/V chanel in a
        // YUV_420 image act as chroma value for 4 neighbouring pixels
        final int uvIndex = (uvh * uvRowStride) + (uvw * uvPixelStride);

        // U/V values ideally fall under [-0.5, 0.5] range. To fit them into
        // [0, 255] range they are scaled up and centered to 128.
        // Operation below brings U/V values to [-128, 127].
        final int u = uBuffer[uvIndex];
        final int v = vBuffer[uvIndex];

        // Compute RGB values per formula above.
        int r = (y + v * 1436 / 1024 - 179).round();
        int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
        int b = (y + u * 1814 / 1024 - 227).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        image.setPixelRgb(w, h, r, g, b);
      }
    }

    return image;
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
