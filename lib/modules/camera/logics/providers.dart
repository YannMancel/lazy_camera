import 'package:camera/camera.dart' as camera;
import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ChangeNotifierProvider, StateNotifierProvider, StateProvider;
import 'package:lazy_camera/_features.dart';

/// Manages the [CameraState].
///
/// The logic owns the methods following:
/// - [CameraLogicBase.reset]
/// - [CameraLogicBase.controller]
/// - [CameraLogicBase.isInitialized]
/// - [CameraLogicBase.onDispose]
final cameraLogicRef =
    StateNotifierProvider.autoDispose<CameraLogicBase, CameraState>(
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

/// Allows to listen the camera data at each refresh of camera controller.
final cameraControllerNotifierRef =
    ChangeNotifierProvider.autoDispose<ValueNotifier<camera.CameraValue>>(
  (ref) {
    final logic = ref.watch(cameraLogicRef.notifier);
    return logic.controller;
  },
  name: 'cameraControllerNotifierRef',
);
