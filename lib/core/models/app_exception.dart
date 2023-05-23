import 'package:freezed_annotation/freezed_annotation.dart'
    show JsonKey, freezed, optionalTypeArgs, useResult;

part 'app_exception.freezed.dart';

@freezed
class AppException with _$AppException implements Exception {
  const AppException._();

  const factory AppException.cameraAccessDenied() = _CameraAccessDenied;
  const factory AppException.cameraAccessDeniedWithoutPrompt() =
      _CameraAccessDeniedWithoutPrompt;
  const factory AppException.cameraAccessRestricted() = _CameraAccessRestricted;
  const factory AppException.audioAccessDenied() = _AudioAccessDenied;
  const factory AppException.audioAccessDeniedWithoutPrompt() =
      _AudioAccessDeniedWithoutPrompt;
  const factory AppException.audioAccessRestricted() = _AudioAccessRestricted;
  const factory AppException.noFrontCamera() = _NoFrontCamera;
  const factory AppException.playingCamera({
    required String message,
  }) = _PlayingCamera;

  const factory AppException.unknown() = _Unknown;

  factory AppException.fromCode(String code) {
    return switch (code) {
      'CameraAccessDenied' => const AppException.cameraAccessDenied(),
      'CameraAccessDeniedWithoutPrompt' =>
        const AppException.cameraAccessDeniedWithoutPrompt(),
      'CameraAccessRestricted' => const AppException.cameraAccessRestricted(),
      'AudioAccessDenied' => const AppException.audioAccessDenied(),
      'AudioAccessDeniedWithoutPrompt' =>
        const AppException.audioAccessDeniedWithoutPrompt(),
      'AudioAccessRestricted' => const AppException.audioAccessRestricted(),
      // No need to noFrontCamera and playingCamera
      _ => const AppException.unknown(),
    };
  }

  String get toLabel {
    return when<String>(
      cameraAccessDenied: () => 'You have denied camera access.',
      cameraAccessDeniedWithoutPrompt: () =>
          'Please go to Settings app to enable camera access.',
      cameraAccessRestricted: () => 'Camera access is restricted.',
      audioAccessDenied: () => 'You have denied audio access.',
      audioAccessDeniedWithoutPrompt: () =>
          'Please go to Settings app to enable audio access.',
      audioAccessRestricted: () => 'Audio access is restricted.',
      noFrontCamera: () => 'No front camera',
      playingCamera: (message) => message,
      unknown: () => 'Unknown error',
    );
  }
}
