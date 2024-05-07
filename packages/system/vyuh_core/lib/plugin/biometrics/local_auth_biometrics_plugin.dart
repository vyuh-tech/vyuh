import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'biometrics_plugin.dart';
import 'exception.dart';

/// [LocalAuthBiometricsPlugin] is a class that is final and
/// it extends the [BiometricsPlugin].
///
/// It uses the [LocalAuthentication] class from the `local_auth` package.
///
/// It has several methods to manage biometrics like:
/// checking if biometrics is available, getting available biometric types,
/// and authenticating the user using biometrics.
final class LocalAuthBiometricsPlugin<BiometricType> extends BiometricsPlugin {
  LocalAuthBiometricsPlugin()
      : super(
            name: 'vyuh.plugin.biometrics.local_auth',
            title: 'Local Auth Biometrics Plugin');

  late final LocalAuthentication _auth;
  late bool _isAuthenticated = false;

  @override
  Future<void> init() async {
    _auth = LocalAuthentication();
  }

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  Future<bool> isBiometricsAvailable() async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch (error) {
      throw BiometricsAvailabilityException(error: error);
    }
  }

  @override
  Future<List<BiometricType>> getAvailableBioMetricType() async {
    try {
      return await _auth.getAvailableBiometrics() as List<BiometricType>;
    } catch (error) {
      throw BiometricsAvailabilityException(error: error);
    }
  }

  @override
  Future<bool> authenticate({
    required String localizedReason,
    AuthenticationOptions options = const AuthenticationOptions(),
  }) async {
    try {
      bool result = await _auth.authenticate(
        localizedReason: localizedReason,
        options: options,
      );
      _isAuthenticated = result;
      return result;
    } on PlatformException catch (error) {
      throw BiometricsPlatformException(
        error: error,
        errorCode: error.code,
      );
    } catch (error) {
      throw BiometricsAuthenticationException(error: error);
    }
  }

  @override
  Future<void> dispose() async {}
}
