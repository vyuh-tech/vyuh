import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// How severe a log message is, from least to most severe, so levels can be
/// compared by [index].
enum LogLevel {
  /// The log level for trace messages.
  /// These are generally used for fine-grained debugging.
  trace,

  /// The log level for debug messages.
  debug,

  /// The log level for info messages. This is the default level.
  info,

  /// The log level for warning messages.
  /// Use this for guiding the developer on correct usage of the concerned API.
  warning,

  /// The log level for error messages. Use this for exceptions and errors.
  error,

  /// The log level for fatal messages.
  /// This is only for the most severe errors, generally considered irrecoverable.
  fatal,
}

/// The default implementation for a Telemetry Plugin.
final class TelemetryPlugin extends Plugin
    with PreloadedPlugin, InitOncePlugin
    implements TelemetryProvider {
  /// The list of providers for the plugin.
  final List<TelemetryProvider> providers;

  @override
  String get description => 'Telemetry Plugin';

  /// Creates a new [TelemetryPlugin].
  TelemetryPlugin({required this.providers})
    : super(name: 'vyuh.plugin.telemetry', title: 'Telemetry Plugin');

  @override
  Future<void> initOnce() => _fanOut((provider) => provider.init());

  @override
  Future<void> disposeOnce() => _fanOut((provider) => provider.dispose());

  @override
  Future<Trace> startTrace(
    String name,
    String operation, {
    LogLevel? level = LogLevel.info,
  }) async {
    final traces = await _startTraces(
      providers,
      (provider) => provider.startTrace(name, operation, level: level),
    );

    return _CompositeTrace(traces, providers: providers);
  }

  @override
  Future<void> reportError(
    exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? params,
    bool fatal = false,
  }) {
    return _fanOut(
      (provider) => provider.reportError(
        exception,
        stackTrace: stackTrace,
        params: params,
        fatal: fatal,
      ),
    );
  }

  @override
  Future<void> reportFlutterError(
    FlutterErrorDetails details, {
    bool fatal = false,
  }) {
    return _fanOut(
      (provider) => provider.reportFlutterError(details, fatal: fatal),
    );
  }

  @override
  Future<void> reportMessage(
    String message, {
    Map<String, dynamic>? params,
    LogLevel? level = LogLevel.info,
  }) {
    return _fanOut(
      (provider) =>
          provider.reportMessage(message, params: params, level: level),
    );
  }

  /// Sends a report to every provider. A provider that fails, synchronously
  /// or asynchronously, is logged and skipped: telemetry must never crash
  /// the app it observes, and one broken provider must not stop the others.
  Future<void> _fanOut(Future<void> Function(TelemetryProvider) report) {
    return Future.wait(
      providers.map((provider) {
        return Future.sync(() => report(provider)).catchError(
          (Object error, StackTrace stack) => _logFailure(provider, error),
        );
      }),
    );
  }

  /// Runs a function with a trace. This is useful for wrapping functions that
  /// need to be traced. It can also be part of a nested trace, using the [parentTrace] parameter.
  Future<T?> trace<T>({
    required String name,
    required String operation,
    required FutureOr<T?> Function(Trace? parentTrace) fn,
    Trace? parentTrace,
    LogLevel? level = LogLevel.info,
  }) async {
    final trace = parentTrace != null
        ? await parentTrace.startChild(name, operation, level: level)
        : await startTrace(name, operation, level: level);

    try {
      final value = fn(trace);
      if (value is Future) {
        return await value;
      }

      return value;
    } catch (ex, stackTrace) {
      await reportError(ex, stackTrace: stackTrace);
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
  Future<void> stop() => Future.wait(
    traces.map(
      (trace) => Future.sync(trace.stop).catchError(
        (Object error, StackTrace stack) => _logFailure(trace, error),
      ),
    ),
  );

  @override
  Future<Trace> startChild(
    String name,
    String operation, {
    LogLevel? level = LogLevel.info,
  }) async {
    final childTraces = await _startTraces(
      traces,
      (trace) => trace.startChild(name, operation, level: level),
    );

    return _CompositeTrace(childTraces, providers: providers);
  }
}

/// Starts a trace on each source. A source that fails gets a [NoOpTrace], so
/// one broken provider never stops the traced work.
Future<List<Trace>> _startTraces<T extends Object>(
  List<T> sources,
  Future<Trace> Function(T source) start,
) => Future.wait(
  sources.map(
    (source) =>
        Future.sync(() => start(source))
            .catchError((Object error, StackTrace stack) {
              _logFailure(source, error);
              return NoOpTrace();
            }),
  ),
);

void _logFailure(Object source, Object error) =>
    debugPrint('Vyuh: telemetry provider ${source.runtimeType} failed: $error');
