import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// The default implementation for an Analytics Plugin.
final class AnalyticsPlugin extends Plugin
    with PreLoadedPlugin
    implements AnalyticsProvider {
  /// The list of providers for the plugin.
  final List<AnalyticsProvider> providers;

  bool _initialized = false;

  @override
  String get description => 'Analytics Plugin';

  /// Creates a new AnalyticsPlugin.
  AnalyticsPlugin({required this.providers})
      : super(
          name: 'vyuh.plugin.analytics',
          title: 'Analytics Plugin',
          pluginType: PluginType.analytics,
        );

  @override
  Future<void> init() async {
    if (_initialized) {
      return;
    }

    await Future.wait(providers.map((e) => e.init()));

    _initialized = true;
  }

  @override
  Future<void> dispose() {
    return Future.wait(providers.map((e) => e.dispose()));
  }

  @override
  Future<AnalyticsTrace> startTrace(String name, String operation) async {
    final traceFutures = providers
        .map((p) => p.startTrace(name, operation))
        .toList(growable: false);
    final traces = await Future.wait(traceFutures);

    return _CompositeAnalyticsTrace(traces, providers: providers);
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
  Future<void> reportEvent(String name, {Map<String, dynamic>? params}) {
    final futures =
        providers.map((provider) => provider.reportEvent(name, params: params));

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
  Future<void> reportMessage(String message, {Map<String, dynamic>? params}) {
    final futures = providers
        .map((provider) => provider.reportMessage(message, params: params));

    return Future.wait(futures);
  }

  /// Runs a function with a trace. This is useful for wrapping functions that
  /// need to be traced. It can also be part of a nested trace, using the [parentTrace] parameter.
  Future<T?> runWithTrace<T>({
    required String name,
    required String operation,
    required FutureOr<T?> Function(AnalyticsTrace? parentTrace) fn,
    AnalyticsTrace? parentTrace,
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
      reportError(ex, stackTrace: stackTrace);
      rethrow;
    } finally {
      await trace.stop();
    }
  }
}

final class _CompositeAnalyticsTrace extends AnalyticsTrace {
  final List<AnalyticsTrace> traces;
  final List<AnalyticsProvider> providers;

  _CompositeAnalyticsTrace(this.traces, {required this.providers});

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
  Future<AnalyticsTrace> startChild(String name, String operation) async {
    final childTraceFutures =
        traces.map((trace) => trace.startChild(name, operation));
    final childTraces = await Future.wait(childTraceFutures);

    return _CompositeAnalyticsTrace(childTraces, providers: providers);
  }
}
