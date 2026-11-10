import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vyuh_core/plugin/env/env_plugin.dart';

/// Reads configuration from a `.env` asset through `flutter_dotenv`.
///
/// It loads into flutter_dotenv's global `dotenv`, so use one
/// [DefaultEnvPlugin] per app.
final class DefaultEnvPlugin extends EnvPlugin {
  final String fileName;

  /// Values used when the env file doesn't set a key. Values in the file
  /// always win.
  final Map<String, String> defaults;

  DefaultEnvPlugin({this.fileName = '.env', this.defaults = const {}})
      : super(name: 'vyuh.env.default', title: 'Default Environment Plugin');

  @override
  Future<void> init() async {
    // dotenv's mergeWith would let these override the file, so add them
    // only for keys the file doesn't set.
    await dotenv.load(fileName: fileName);
    final env = dotenv.env;
    for (final entry in defaults.entries) {
      env.putIfAbsent(entry.key, () => entry.value);
    }
  }

  @override
  Map<String, String> all() => Map.unmodifiable(dotenv.env);

  @override
  clear() {
    dotenv.clean();
  }

  @override
  Future<void> dispose() async {
    dotenv.clean();
  }

  @override
  String get(String key, {String? fallback}) {
    return dotenv.get(key, fallback: fallback);
  }

  @override
  String? maybeGet(String key, {String? fallback}) {
    return dotenv.maybeGet(key, fallback: fallback);
  }
}
