import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// A no-op implementation of [TelemetryProvider] that can be used for development
/// or testing purposes.
///
/// This provider implements all telemetry operations as no-ops, meaning they do
/// nothing when called. This is useful for:
/// - Development environments where telemetry is not needed
/// - Testing where telemetry should be disabled
/// - Prototyping before implementing a real telemetry provider
///
/// Example:
/// ```dart
/// final plugins = PluginDescriptor(
///   telemetry: TelemetryPlugin(providers: [NoOpTelemetryProvider()]),
/// );
/// ```
///
/// WARNING: Do not use this provider in production. Replace it with a real
/// telemetry provider that can properly track errors and performance.
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

/// A no-op implementation of [Trace] that can be used for development or testing.
///
/// This trace implementation does nothing when its methods are called. It is
/// returned by [NoOpTelemetryProvider] when starting a trace.
///
/// All operations are implemented as no-ops:
/// - [getAttributes] returns an empty map
/// - [getMetric] returns 0
/// - [setAttributes] and [setMetric] do nothing
/// - [stop] returns immediately
/// - [startChild] returns a new [NoOpTrace]
///
/// Example:
/// ```dart
/// final trace = await telemetry.startTrace('MyOperation', 'Start');
/// await doSomething();
/// await trace.stop(); // Does nothing with NoOpTrace
/// ```
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
