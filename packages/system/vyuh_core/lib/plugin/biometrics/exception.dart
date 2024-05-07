abstract class BiometricsException implements Exception {
  const BiometricsException({
    this.message = 'Biometrics error',
    this.error,
  });

  final Object? error;

  final String message;

  @override
  String toString() {
    return '[$runtimeType]: $error';
  }
}

class BiometricsPlatformException extends BiometricsException {
  const BiometricsPlatformException({
    super.message = 'Biometrics Platform error',
    super.error,
    this.errorCode = 'unknown',
  });

  final String errorCode;

  @override
  String toString() {
    return '[$runtimeType]: $errorCode - $error';
  }
}

class BiometricsAuthenticationException extends BiometricsException {
  const BiometricsAuthenticationException({
    super.message = 'Biometrics authentication failed',
    super.error,
  });
}

class BiometricsAvailabilityException extends BiometricsException {
  const BiometricsAvailabilityException({
    super.message = 'Biometrics availability check failed',
    super.error,
  });
}
