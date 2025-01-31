import 'package:vyuh_core/vyuh_core.dart';

abstract interface class Logger {
  void trace(dynamic message);

  void debug(dynamic message);

  void info(dynamic message);

  void warn(dynamic message);

  void error(dynamic message, {Object? error});

  void fatal(dynamic message, {Object? error, StackTrace? stackTrace});
}

final class _DefaultLogger implements Logger {
  late final VyuhPlatform platform;

  bool initialized = false;

  @override
  void trace(dynamic message) {
    platform.telemetry.reportMessage(message, level: LogLevel.trace);
  }

  @override
  void debug(dynamic message) {
    platform.telemetry.reportMessage(message, level: LogLevel.debug);
  }

  @override
  void info(dynamic message) {
    platform.telemetry.reportMessage(message, level: LogLevel.info);
  }

  @override
  void warn(dynamic message) {
    platform.telemetry.reportMessage(message, level: LogLevel.warning);
  }

  @override
  void error(dynamic message, {Object? error}) {
    platform.telemetry.reportMessage(message, level: LogLevel.error);
  }

  @override
  void fatal(dynamic message, {Object? error, StackTrace? stackTrace}) {
    platform.telemetry.reportMessage(message, level: LogLevel.fatal);
  }
}

/// A convenience wrapper to provide a Logger interface to the Telemetry reportMessage() calls.
extension LoggerInterface on VyuhPlatform {
  static final _logger = _DefaultLogger();
  Logger get log {
    if (!_logger.initialized) {
      _logger.platform = this;
      _logger.initialized = true;
    }

    return _logger;
  }
}
