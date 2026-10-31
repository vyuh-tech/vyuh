library;

import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:vyuh_core/vyuh_core.dart' hide Logger;

/// A telemetry provider that logs to the console using the logger package.
final class ConsoleLoggerTelemetryProvider implements TelemetryProvider {
  Logger _logger = _createLogger();

  @override
  String get name => 'vyuh.plugin.telemetry.provider.console';

  @override
  String get title => 'Console Logger Telemetry Provider';

  @override
  String get description => 'A simple Console-logger Telemetry Provider';

  ConsoleLoggerTelemetryProvider();

  @override
  Future<void> dispose() {
    return Future.sync(() => _logger.close());
  }

  @override
  Future<void> init() {
    return Future.sync(() {
      if (_logger.isClosed() == false) {
        _logger.close();
      }

      _logger = _createLogger();
    });
  }

  @override
  Future<void> reportError(exception,
      {StackTrace? stackTrace,
      Map<String, dynamic>? params,
      bool fatal = false}) async {
    final message = _withParams('Error observed', params);
    if (fatal) {
      _logger.f(message, error: exception, stackTrace: stackTrace);
    } else {
      _logger.e(message, error: exception, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> reportFlutterError(FlutterErrorDetails details,
      {bool fatal = false}) async {
    (fatal ? _logger.f : _logger.e)('''
Flutter Error observed in ${details.library}
-----
${details.summary}
''', error: details.exception, stackTrace: details.stack);
  }

  @override
  Future<void> reportMessage(String message,
      {Map<String, dynamic>? params, LogLevel? level = LogLevel.info}) async {
    message = _withParams(message, params);
    switch (level) {
      case LogLevel.fatal:
        _logger.f(message);
        break;
      case LogLevel.error:
        _logger.e(message);
        break;
      case LogLevel.warning:
        _logger.w(message);
        break;
      case LogLevel.info:
        _logger.i(message);
        break;
      case LogLevel.debug:
        _logger.d(message);
        break;
      case LogLevel.trace:
        _logger.t(message);
        break;
      default:
        _logger.i(message);
    }
  }

  @override
  Future<Trace> startTrace(String name, String operation,
      {LogLevel? level = LogLevel.info}) async {
    return NoOpTrace();
  }
}

String _withParams(String message, Map<String, dynamic>? params) =>
    params == null || params.isEmpty ? message : '$message $params';

Logger _createLogger() {
  return Logger(
    level: Level.all,
    printer: PrettyPrinter(
      colors: false,
      noBoxingByDefault: true,
      methodCount: 0,
      lineLength: 80,
    ),
  );
}
