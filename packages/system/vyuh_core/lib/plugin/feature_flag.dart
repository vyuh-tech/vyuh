import 'package:vyuh_core/vyuh_core.dart';

/// The base class for a Feature Flag plugin.
/// Feature Flags are useful to control the visibility of features in an application.
/// They are setup on the server side and can be controlled by the server to
/// enable/disable features for different users.
abstract base class FeatureFlagPlugin<TSettings, TContext> extends Plugin {
  /// The settings for the feature flag plugin.
  final TSettings settings;

  FeatureFlagPlugin({
    required this.settings,
    required super.name,
    required super.title,
  }) : super(pluginType: PluginType.featureFlag);

  /// Returns the value of the feature flag as a boolean.
  Future<bool> getBool(String featureName, {bool defaultValue = false});

  /// Returns the value of the feature flag as a string.
  Future<String> getString(String featureName, {String defaultValue = ''});

  /// Returns the value of the feature flag as an integer.
  Future<int> getInt(String featureName, {int defaultValue = 0});

  /// Returns the value of the feature flag as a double.
  Future<double> getDouble(String featureName, {double defaultValue = 0.0});

  /// Returns the value of the feature flag as a JSON object represented by a Map.
  Future<Map<String, dynamic>> getJson(String featureName,
      {Map<String, dynamic> defaultValue = const {}});

  /// Sets the default values for the feature flags.
  /// This is useful when the plugin is first initialized and want to set defaults before fetching the actual values.
  Future<void> setDefaults(Map<String, dynamic> defaults);

  /// Updates the context of the feature flag plugin. This could include setting
  /// the user id, user attributes, locale, etc.
  Future<void> updateContext(TContext context);

  /// Refreshes the feature flags. This is useful to force an update on the feature flag values.
  Future<void> refresh();
}
