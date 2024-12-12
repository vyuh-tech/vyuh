import 'package:vyuh_core/vyuh_core.dart';

abstract class LoggerPlugin extends Plugin {
  LoggerPlugin({required super.name, required super.title});

  /// trace
  void trace(dynamic message);

  /// debug
  void debug(dynamic message);

  /// info
  void info(dynamic message);

  /// warn
  void warn(dynamic message);

  /// error
  void error(dynamic message, {Object? error});

  /// fatal
  void fatal(dynamic message, {Object? error, StackTrace? stackTrace});
}

final class NoOpLoggerPlugin extends LoggerPlugin {
  NoOpLoggerPlugin()
      : super(name: 'vyuh.plugin.logger.noop', title: 'No Op LoggerPlugin');

  @override
  void trace(dynamic message) {}

  @override
  void debug(dynamic message) {}

  @override
  void info(dynamic message) {}

  @override
  void warn(dynamic message) {}

  @override
  void error(dynamic message, {Object? error}) {}

  @override
  void fatal(dynamic message, {Object? error, StackTrace? stackTrace}) {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> init() async {}
}
