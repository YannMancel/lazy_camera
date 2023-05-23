import 'package:freezed_annotation/freezed_annotation.dart'
    show freezed, optionalTypeArgs;

part 'camera_state.freezed.dart';

@freezed
class CameraState with _$CameraState {
  const factory CameraState.uninitialized() = _Uninitialized;
  const factory CameraState.initialized() = _Initialized;
}
