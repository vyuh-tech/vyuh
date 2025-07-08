import 'package:vyuh_core/plugin/plugin.dart';

/// An abstract class representing an environment plugin.
/// It provides methods to interact with environment variables.
abstract class EnvPlugin extends Plugin {
  /// Constructs an `EnvPlugin` with the given name and title.
  ///
  /// The [name] parameter specifies the name of the plugin.
  /// The [title] parameter specifies the title of the plugin.
  EnvPlugin({required super.name, required super.title});

  /// Returns a map of all environment variables.
  ///
  /// The keys are the names of the environment variables, and the values are their corresponding values.
  Map<String, String?> all();

  /// Returns the value of the environment variable specified by [key], or the [fallback] value if not found.
  String get(String key, {String? fallback});

  /// Returns the value of the environment variable specified by [key],
  /// or the [fallback] value if not found, or null if neither is found.
  String? maybeGet(String key, {String? fallback});

  /// Clears all the environment variables.
  void clear();
}
