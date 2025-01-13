import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// A no-op implementation of [TelemetryProvider].
final class NoOpTelemetryProvider implements TelemetryProvider {
  @override
  Future<Trace> startTrace(
    String name,
    String operation, {
    LogLevel? level = LogLevel.info,
  }) async =>
      NoOpTrace();

  @override
  String get name => 'vyuh.plugin.telemetry.provider.noop';

  @override
  String get title => 'No Op Telemetry Provider';

  @override
  String get description =>
      '''No Op Telemetry Provider. No events will be sent. 
      Ensure a real TelemetryProvider is set before going to Production.''';

  @override
  Future<void> dispose() => Future.value();

  @override
  Future<void> init() => Future.value();

  @override
  Future<void> reportError(exception,
      {StackTrace? stackTrace,
      Map<String, dynamic>? params,
      bool fatal = false}) {
    return Future.value();
  }

  @override
  Future<void> reportFlutterError(FlutterErrorDetails details,
      {bool fatal = false}) {
    return Future.value();
  }

  @override
  Future<void> reportMessage(
    String message, {
    Map<String, dynamic>? params,
    LogLevel? level = LogLevel.info,
  }) {
    return Future.value();
  }
}

final class NoOpTrace extends Trace {
  @override
  Map<String, String> getAttributes() => {};

  @override
  int getMetric(String name) => 0;

  @override
  void setAttributes(Map<String, String> attributes) {}

  @override
  void setMetric(String name, int value) {}

  @override
  Future<void> stop() {
    return Future.value();
  }

  @override
  Future<Trace> startChild(
    String name,
    String operation, {
    LogLevel? level = LogLevel.info,
  }) {
    return Future.value(NoOpTrace());
  }
}
