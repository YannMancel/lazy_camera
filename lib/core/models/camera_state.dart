import 'dart:typed_data' show Uint8List;

import 'package:freezed_annotation/freezed_annotation.dart'
    show DeepCollectionEquality, JsonKey, freezed, optionalTypeArgs, useResult;

part 'camera_state.freezed.dart';

@freezed
class CameraState with _$CameraState {
  const factory CameraState.uninitialized() = _Uninitialized;
  const factory CameraState.preview() = _Preview;
  const factory CameraState.imageStream({Uint8List? bytes}) = _ImageStream;
}
