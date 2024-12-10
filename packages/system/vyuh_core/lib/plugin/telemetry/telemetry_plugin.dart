import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:vyuh_core/plugin/plugin.dart';
import 'package:vyuh_core/plugin/telemetry/telemetry_provider.dart';
import 'package:vyuh_core/runtime/platform/vyuh_platform.dart';

import 'logger.dart';

/// The default implementation for an Analytics Plugin.
final class TelemetryPlugin extends Plugin
    with PreloadedPlugin, InitOncePlugin
    implements TelemetryProvider {
  /// The list of providers for the plugin.
  final List<TelemetryProvider> providers;

  @override
  String get description => 'Analytics Plugin';

  /// Creates a new AnalyticsPlugin.
  TelemetryPlugin({required this.providers})
      : super(
          name: 'vyuh.plugin.telemetry',
          title: 'Telemetry Plugin',
        );

  @override
  Future<void> initialise() async {
    await Future.wait(providers.map((e) => e.init()));
  }

  @override
  Future<Trace> startTrace(String name, String operation) async {
    final traceFutures = providers
        .map((p) => p.startTrace(name, operation))
        .toList(growable: false);
    final traces = await Future.wait(traceFutures);

    return _CompositeTrace(traces, providers: providers);
  }

  @override
  List<NavigatorObserver> get observers =>
      providers.expand((element) => element.observers).toList(growable: false);

  @override
  Future<void> reportError(exception,
      {StackTrace? stackTrace,
      Map<String, dynamic>? params,
      bool fatal = false}) {
    final futures = providers.map((provider) => provider.reportError(
          exception,
          stackTrace: stackTrace,
          params: params,
          fatal: fatal,
        ));

    return Future.wait(futures);
  }

  @override
  Future<void> reportFlutterError(FlutterErrorDetails details,
      {bool fatal = false}) {
    final futures = providers
        .map((provider) => provider.reportFlutterError(details, fatal: fatal));

    return Future.wait(futures);
  }

  @override
  Future<void> reportMessage(String message,
      {LogLevel level = LogLevel.info, Map<String, dynamic>? params}) {
    final futures = providers.map((provider) =>
        provider.reportMessage(message, params: params, level: level));

    return Future.wait(futures);
  }

  /// Runs a function with a trace. This is useful for wrapping functions that
  /// need to be traced. It can also be part of a nested trace, using the [parentTrace] parameter.
  Future<T?> trace<T>({
    required String name,
    required String operation,
    required FutureOr<T?> Function(Trace trace) fn,
    Trace? parentTrace,
  }) async {
    final trace = parentTrace != null
        ? await parentTrace.startChild(name, operation)
        : await startTrace(name, operation);

    try {
      final value = fn(trace);
      if (value is Future) {
        return await value;
      }

      return value;
    } catch (ex, stackTrace) {
      trace.exception = ex;
      reportError(ex, stackTrace: stackTrace);
      rethrow;
    } finally {
      await trace.stop();
    }
  }
}

final class _CompositeTrace extends Trace {
  final List<Trace> traces;
  final List<TelemetryProvider> providers;

  _CompositeTrace(this.traces, {required this.providers});

  @override
  Map<String, String> getAttributes() {
    return traces.firstOrNull?.getAttributes() ?? {};
  }

  @override
  int getMetric(String name) {
    return traces.firstOrNull?.getMetric(name) ?? 0;
  }

  @override
  void setAttributes(Map<String, String> attributes) {
    for (var trace in traces) {
      trace.setAttributes(attributes);
    }
  }

  @override
  void setMetric(String name, int value) {
    for (var trace in traces) {
      trace.setMetric(name, value);
    }
  }

  @override
  Future<void> stop() => Future.wait(traces.map((e) => e.stop()));

  @override
  Future<Trace> startChild(String name, String operation) async {
    final childTraceFutures =
        traces.map((trace) => trace.startChild(name, operation));
    final childTraces = await Future.wait(childTraceFutures);

    return _CompositeTrace(childTraces, providers: providers);
  }

  @override
  set exception(exception) {
    for (var trace in traces) {
      trace.exception = exception;
    }
  }
}

/// An extension on [VyuhPlatform] to provide telemetry capabilities.
///
/// This extension adds a getter to access the [TelemetryPlugin] and a direct
/// reference to the `trace` functionality from Vyuh's telemetry.
///
/// Example usage:
/// ```dart
/// final telemetry = VyuhPlatform().telemetry;
/// telemetry.trace(name: 'trace_name', operation: 'some_operation', fn: (final trace) {});
/// ```
///
/// ```dart
/// vyuh.trace(name: 'trace_name', operation: 'some_operation', fn: (final trace) {});
/// ```
extension TelemetryInterface on VyuhPlatform {
  TelemetryPlugin get telemetry => getPlugin<TelemetryPlugin>()!;

  Future<T?> Function<T>({
    required String name,
    required String operation,
    required FutureOr<T?> Function(Trace trace) fn,
    Trace? parentTrace,
  }) get trace => vyuh.telemetry.trace;
}
