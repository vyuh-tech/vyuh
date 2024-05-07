import 'package:vyuh_core/vyuh_core.dart';

/// `BiometricsPlugin` is an abstract class that extends the [Plugin] class.
///
/// It is associated with the Biometrics Plugin type[PluginType.biometrics] and
/// it has several methods to manage biometrics like:
/// checking if biometrics is available, getting available biometric types,
/// and authenticating the user using biometrics.
abstract base class BiometricsPlugin<T> extends Plugin {
  /// The `BiometricsPlugin` constructor accepts two required parameters: `name` and `title`.
  BiometricsPlugin({required super.name, required super.title})
      : super(pluginType: PluginType.biometrics);

  /// Returns true if the user is authenticated using biometrics.
  bool get isAuthenticated;

  /// Returns true if biometrics is available on the device.
  Future<bool> isBiometricsAvailable();

  /// Retrieves the available biometric types.
  Future<List<T>> getAvailableBioMetricType();

  /// Authenticates the user using biometrics and returns true if authenticated.
  ///
  /// [localizedReason] is the message to show to user while prompting them
  /// for authentication. This is typically along the lines of: 'Authenticate
  /// to access MyApp.'. This must not be empty.
  Future<bool> authenticate({required String localizedReason});
}
