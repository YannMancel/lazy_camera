import 'dart:async';

import 'package:camera/camera.dart' as camera;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazy_camera/_features.dart';

abstract interface class CameraLogicInterface {
  Future<List<camera.CameraDescription>> getAvailableCameras();
}

final class CameraLogic implements CameraLogicInterface {
  CameraLogic(Ref ref) : _ref = ref;

  final Ref _ref;

  StateController<AppException?> get _errorManager {
    return _ref.read(appExceptionRef.notifier);
  }

  set _error(AppException exception) => _errorManager.state = exception;

  @override
  Future<List<camera.CameraDescription>> getAvailableCameras() async {
    late List<camera.CameraDescription> cameras;

    try {
      cameras = await camera.availableCameras();
    } on camera.CameraException catch (e) {
      _error = AppException.fromCode(e.code);
      cameras = List<camera.CameraDescription>.empty();
    } catch (e) {
      _error = UnknownRestricted();
      cameras = List<camera.CameraDescription>.empty();
    }

    return cameras;
  }
}
