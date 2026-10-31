import 'package:vyuh_core/vyuh_core.dart';

/// Leveled logging over the telemetry plugin. Every message goes to
/// `reportMessage` as text; [error] and [fatal] also report their error, with
/// its stack trace, through `reportError`.
abstract interface class Logger {
  void trace(dynamic message);

  void debug(dynamic message);

  void info(dynamic message);

  void warn(dynamic message);

  void error(dynamic message, {Object? error, StackTrace? stackTrace});

  void fatal(dynamic message, {Object? error, StackTrace? stackTrace});
}

final class _DefaultLogger implements Logger {
  TelemetryPlugin get _telemetry => VyuhBinding.instance.telemetry;

  void _log(
    dynamic message,
    LogLevel level, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final text = '$message';
    _telemetry.reportMessage(text, level: level);
    if (error != null) {
      _telemetry.reportError(
        error,
        stackTrace: stackTrace,
        params: {'message': text},
        fatal: level == LogLevel.fatal,
      );
    }
  }

  @override
  void trace(dynamic message) => _log(message, LogLevel.trace);

  @override
  void debug(dynamic message) => _log(message, LogLevel.debug);

  @override
  void info(dynamic message) => _log(message, LogLevel.info);

  @override
  void warn(dynamic message) => _log(message, LogLevel.warning);

  @override
  void error(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      _log(message, LogLevel.error, error: error, stackTrace: stackTrace);

  @override
  void fatal(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      _log(message, LogLevel.fatal, error: error, stackTrace: stackTrace);
}

/// A convenience wrapper to provide a Logger interface to the Telemetry reportMessage() calls.
extension LoggerInterface on VyuhBinding {
  static final _logger = _DefaultLogger();
  Logger get log => _logger;
}

extension PlatformLoggerInterface on VyuhPlatform {
  Logger get log => VyuhBinding.instance.log;
}
