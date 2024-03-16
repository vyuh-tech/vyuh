import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class AnalyticsPlugin extends Plugin implements AnalyticsProvider {
  final List<AnalyticsProvider> providers;

  bool _initialized = false;

  @override
  String get description => 'Analytics Plugin';

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
  AnalyticsTrace createTrace(String name) {
    final traces = providers.map((element) => element.createTrace(name));
    return CompositeAnalyticsTrace(traces.toList(growable: false));
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

  Future<T?> runWithTrace<T>(String name, FutureOr<T?> Function() fn) async {
    final trace = createTrace(name);
    await trace.start();
    try {
      final value = fn();
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

final class CompositeAnalyticsTrace extends AnalyticsTrace {
  final List<AnalyticsTrace> traces;

  CompositeAnalyticsTrace(this.traces);

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
  Future<void> start() => Future.wait(traces.map((e) => e.start()));

  @override
  Future<void> stop() => Future.wait(traces.map((e) => e.stop()));
}
