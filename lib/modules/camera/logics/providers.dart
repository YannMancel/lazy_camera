import 'package:hooks_riverpod/hooks_riverpod.dart'
    show StateNotifierProvider, StateProvider;
import 'package:lazy_camera/_features.dart';

/// Manages the [CameraState].
///
/// The logic owns the methods following:
/// - [CameraLogicInterface.reset]
/// - [CameraLogicInterface.controller]
/// - [CameraLogicInterface.isInitialized]
/// - [CameraLogicInterface.startImageStream]
/// - [CameraLogicInterface.onDispose]
final cameraLogicRef =
    StateNotifierProvider.autoDispose<CameraLogicInterface, CameraState>(
  (ref) {
    final logic = CameraLogic(ref);
    ref.onDispose(logic.onDispose);
    return logic;
  },
  name: 'cameraLogicRef',
);

/// Allows to listen if an [AppException] is throw during the camera process
/// with [cameraLogicRef].
final appExceptionRef = StateProvider.autoDispose<AppException?>(
  (_) => null,
  name: 'appExceptionRef',
);
