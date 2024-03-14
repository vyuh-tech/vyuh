import 'package:vyuh_core/vyuh_core.dart';

abstract base class LoggerPlugin extends Plugin {
  LoggerPlugin({required super.name, required super.title})
      : super(pluginType: PluginType.logger);

  /// trace
  void t(dynamic message);

  /// debug
  void d(dynamic message);

  /// info
  void i(dynamic message);

  /// warn
  void w(dynamic message);

  /// error
  void e(dynamic message, {Object? error});

  /// fatal
  void f(dynamic message, {Object? error, StackTrace? stackTrace});
}
