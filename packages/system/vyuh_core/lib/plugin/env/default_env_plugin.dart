import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vyuh_core/plugin/env/env_plugin.dart';

final class DefaultEnvPlugin extends EnvPlugin {
  final String fileName;
  final Map<String, String> defaults;

  DefaultEnvPlugin({this.fileName = '.env', this.defaults = const {}})
      : super(name: 'vyuh.env.default', title: 'Default Environment Plugin');

  @override
  Future<void> init() async {
    await dotenv.load(fileName: fileName, mergeWith: defaults);
  }

  @override
  Map<String, String> all() => dotenv.env;

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
