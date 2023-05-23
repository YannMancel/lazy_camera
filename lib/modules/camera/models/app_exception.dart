sealed class AppException implements Exception {
  static AppException fromCode(String code) {
    return switch (code) {
      'CameraAccessDenied' => CameraAccessDenied(),
      'CameraAccessDeniedWithoutPrompt' => CameraAccessDeniedWithoutPrompt(),
      'CameraAccessRestricted' => CameraAccessRestricted(),
      'AudioAccessDenied' => AudioAccessDenied(),
      'AudioAccessDeniedWithoutPrompt' => AudioAccessDeniedWithoutPrompt(),
      'AudioAccessRestricted' => AudioAccessRestricted(),
      _ => UnknownRestricted(),
    };
  }

  static String toLabel(AppException exception) {
    return switch (exception) {
      CameraAccessDenied() => 'You have denied camera access.',
      CameraAccessDeniedWithoutPrompt() =>
        'Please go to Settings app to enable camera access.',
      CameraAccessRestricted() => 'Camera access is restricted.',
      AudioAccessDenied() => 'You have denied audio access.',
      AudioAccessDeniedWithoutPrompt() =>
        'Please go to Settings app to enable audio access.',
      AudioAccessRestricted() => 'Audio access is restricted.',
      _ => 'Unknown error',
    };
  }
}

class CameraAccessDenied extends AppException {}

class CameraAccessDeniedWithoutPrompt extends AppException {}

class CameraAccessRestricted extends AppException {}

class AudioAccessDenied extends AppException {}

class AudioAccessDeniedWithoutPrompt extends AppException {}

class AudioAccessRestricted extends AppException {}

class UnknownRestricted extends AppException {}
