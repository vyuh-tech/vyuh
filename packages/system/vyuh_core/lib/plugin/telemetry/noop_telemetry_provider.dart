import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:vyuh_core/plugin/telemetry/telemetry_provider.dart';

import 'logger.dart';

/// A no-op implementation of [TelemetryProvider].
class NoOpTelemetryProvider implements TelemetryProvider {
  @override
  Future<Trace> startTrace(String name, String operation) =>
      Future.value(_NoOpTrace());

  @override
  String get name => 'vyuh.analyticsProvider.noop';

  @override
  String get title => 'No Op Analytics Provider';

  @override
  String get description =>
      '''No Op Analytics Provider. No events will be sent. 
      Ensure a real AnalyticsProvider is set before going to Production.''';

  @override
  Future<void> dispose() => Future.value();

  @override
  Future<void> init() => Future.value();

  @override
  List<NavigatorObserver> get observers => [];

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
  Future<void> reportMessage(String message,
      {required LogLevel level, Map<String, dynamic>? params}) {
    return Future.value();
  }
}

final class _NoOpTrace extends Trace {
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
  Future<Trace> startChild(String name, String operation) {
    return Future.value(_NoOpTrace());
  }

  @override
  set exception(exception) {}
}
