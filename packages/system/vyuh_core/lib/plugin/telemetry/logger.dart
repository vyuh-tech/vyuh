import '../../vyuh_core.dart';

/// A utility for logging messages with varying levels of severity.
///
/// The `Logger` class provides methods to log messages with different
/// levels such as `trace`, `debug`, `info`, `warning`, `error`, and `fatal`.
/// The logs are reported using the telemetry system.
///
/// Example usage:
///
/// ```dart
/// vyuh.log.d('This is a debug message');
/// vyuh.log.e('An error occurred', params: {'code': 500});
/// ```
///
/// Note: This class is implemented as a singleton. Use
/// `vyuh.log` to access the instance.
final class Logger {
  /// The singleton instance of the `Logger` class.
  static final Logger _instance = Logger._();

  // Private constructor for singleton pattern.
  Logger._();

  /// Logs a message with the `trace` severity level.
  ///
  /// The `t` method reports `message` with `LogLevel.trace`.
  ///
  /// - [message]: The message to log.
  /// - [params]: Optional additional parameters for the log message.
  void t(String message, {Map<String, dynamic>? params}) {
    vyuh.telemetry
        .reportMessage(message, level: LogLevel.trace, params: params);
  }

  /// Logs a message with the `debug` severity level.
  ///
  /// The `d` method reports `message` with `LogLevel.debug`.
  ///
  /// - [message]: The message to log.
  /// - [params]: Optional additional parameters for the log message.
  void d(String message, {Map<String, dynamic>? params}) {
    vyuh.telemetry
        .reportMessage(message, level: LogLevel.debug, params: params);
  }

  /// Logs a message with the `info` severity level.
  ///
  /// The `i` method reports `message` with `LogLevel.info`.
  ///
  /// - [message]: The message to log.
  /// - [params]: Optional additional parameters for the log message.
  void i(String message, {Map<String, dynamic>? params}) {
    vyuh.telemetry.reportMessage(message, level: LogLevel.info, params: params);
  }

  /// Logs a message with the `warning` severity level.
  ///
  /// The `w` method reports `message` with `LogLevel.warning`.
  ///
  /// - [message]: The message to log.
  /// - [params]: Optional additional parameters for the log message.
  void w(String message, {Map<String, dynamic>? params}) {
    vyuh.telemetry
        .reportMessage(message, level: LogLevel.warning, params: params);
  }

  /// Logs a message with the `error` severity level.
  ///
  /// The `e` method reports `message` with `LogLevel.error`.
  ///
  /// - [message]: The message to log.
  /// - [params]: Optional additional parameters for the log message.
  void e(String message, {Map<String, dynamic>? params}) {
    vyuh.telemetry
        .reportMessage(message, level: LogLevel.error, params: params);
  }

  /// Logs a message with the `fatal` severity level.
  ///
  /// The `f` method reports `message` with `LogLevel.fatal`.
  ///
  /// - [message]: The message to log.
  /// - [params]: Optional additional parameters for the log message.
  void f(String message, {Map<String, dynamic>? params}) {
    vyuh.telemetry
        .reportMessage(message, level: LogLevel.fatal, params: params);
  }
}

/// Represents the different levels of log severity.
///
/// - `trace`: The most detailed information. Typically used for
/// troubleshooting specific issues.
/// - `debug`: Useful for debugging the application.
/// - `info`: General informational messages.
/// - `warning`: Indications that something unexpected happened or might
/// cause problems in the future.
/// - `error`: Error events that might still allow the application to
/// continue running.
/// - `fatal`: Very severe error events that will likely cause the
/// application to terminate.
enum LogLevel {
  trace,
  debug,
  info,
  warning,
  error,
  fatal,
}

extension LoggerInterface on VyuhPlatform {
  Logger get log => Logger._instance;
}
