import 'package:vyuh_core/plugin/env/env_plugin.dart';

/// The default environment plugin: it holds no values. [get] throws and
/// [maybeGet] returns its fallback.
final class NoOpEnvPlugin extends EnvPlugin {
  final String fileName;
  final Map<String, String> defaults;

  NoOpEnvPlugin({this.fileName = '.env', this.defaults = const {}})
      : super(name: 'vyuh.env.noop', title: 'No-Op Environment Plugin');

  @override
  Future<void> init() async {}

  @override
  Map<String, String> all() => const {};

  @override
  clear() {}

  @override
  Future<void> dispose() async {}

  @override
  String get(String key, {String? fallback}) {
    throw UnsupportedError(
        'You are using a No-Op Environment Plugin, which does not support this operation.');
  }

  @override
  String? maybeGet(String key, {String? fallback}) => fallback;
}
