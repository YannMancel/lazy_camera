import 'package:camera/camera.dart' as camera;
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show FutureProvider, Provider, StateProvider;
import 'package:lazy_camera/_features.dart';

final _cameraLogicRef = Provider<CameraLogicInterface>(
  (ref) => CameraLogic(ref),
  name: '_cameraLogicRef',
);

final availableCamerasRef = FutureProvider<List<camera.CameraDescription>>(
  (ref) {
    final logic = ref.watch(_cameraLogicRef);
    return logic.getAvailableCameras();
  },
  name: 'availableCamerasRef',
);

final appExceptionRef = StateProvider<AppException?>(
  (_) => null,
  name: 'appExceptionRef',
);
