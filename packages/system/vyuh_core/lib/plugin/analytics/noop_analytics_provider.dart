import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// A no-op implementation of [AnalyticsProvider].
final class NoOpAnalyticsProvider implements AnalyticsProvider {
  @override
  @Deprecated("Moved to Telemetry Provider Start Trace")
  Future<AnalyticsTrace> startTrace(String name, String operation) async =>
      _NoOpAnalyticsTrace();

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
  @Deprecated("Moved to Telemetry Provider Report Error")
  Future<void> reportError(exception,
      {StackTrace? stackTrace,
      Map<String, dynamic>? params,
      bool fatal = false}) {
    return Future.value();
  }

  @override
  Future<void> reportEvent(String name, {Map<String, dynamic>? params}) {
    return Future.value();
  }

  @override
  @Deprecated("Moved to Telemetry Provider Report Flutter Error")
  Future<void> reportFlutterError(FlutterErrorDetails details,
      {bool fatal = false}) {
    return Future.value();
  }

  @override
  @Deprecated("Moved to Telemetry Provider Report Message")
  Future<void> reportMessage(String message, {Map<String, dynamic>? params}) {
    return Future.value();
  }
}

@Deprecated("Moved to Telemetry No Op Trace")
final class _NoOpAnalyticsTrace extends AnalyticsTrace {
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
  Future<AnalyticsTrace> startChild(String name, String operation) {
    return Future.value(_NoOpAnalyticsTrace());
  }
}
