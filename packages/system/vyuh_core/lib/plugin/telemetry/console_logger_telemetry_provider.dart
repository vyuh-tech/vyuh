import 'package:logger/logger.dart' as log;
import 'package:vyuh_core/plugin/telemetry/logger.dart';

import 'noop_telemetry_provider.dart';

class ConsoleLoggerTelemetryProvider extends NoOpTelemetryProvider {
  final logger = _createLogger();

  @override
  Future<void> reportMessage(String message,
      {required LogLevel level, Map<String, dynamic>? params}) async {
    switch (level) {
      case LogLevel.trace:
        logger.t(_generateMessage(message, params));
      case LogLevel.debug:
        logger.d(_generateMessage(message, params));
      case LogLevel.info:
        logger.i(_generateMessage(message, params));
      case LogLevel.warning:
        logger.w(_generateMessage(message, params));
      case LogLevel.error:
        logger.e(_generateMessage(message, params));
      case LogLevel.fatal:
        logger.f(_generateMessage(message, params));
    }
  }

  @override
  final String title = "Console Logger Telemetry Provider";
}

Map<String, dynamic> _generateMessage(String message, dynamic params) {
  return {"message": message, if (params != null) "params": params};
}

log.Logger _createLogger() {
  return log.Logger(
    level: log.Level.all,
    printer: log.PrettyPrinter(
      colors: false,
      noBoxingByDefault: true,
      methodCount: 0,
      lineLength: 80,
    ),
  );
}
