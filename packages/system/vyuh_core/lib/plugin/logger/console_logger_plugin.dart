import 'package:logger/logger.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class ConsoleLoggerPlugin extends LoggerPlugin {
  Logger _logger = _createLogger();

  ConsoleLoggerPlugin()
      : super(
            name: 'vyuh.plugin.logger.console', title: 'Console Logger Plugin');

  @override
  void debug(message) {
    _logger.d(message);
  }

  @override
  void error(message, {Object? error}) {
    _logger.e(message);
  }

  @override
  void fatal(message, {Object? error, StackTrace? stackTrace}) {
    _logger.f(message);
  }

  @override
  void info(message) {
    _logger.i(message);
  }

  @override
  void trace(message) {
    _logger.t(message);
  }

  @override
  void warn(message) {
    _logger.w(message);
  }

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
}

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
