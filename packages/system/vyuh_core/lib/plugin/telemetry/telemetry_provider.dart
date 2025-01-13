import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// The base interface for an Telemetry Provider. The provider is responsible for
/// reporting telemetry events, errors, and messages.
abstract interface class TelemetryProvider {
  /// The name of the provider.
  String get name;

  /// The title of the provider.
  String get title;

  /// The description of the provider.
  String get description;

  /// Initializes the provider.
  Future<void> init();

  /// Disposes the provider.
  Future<void> dispose();

  /// Reports an error with an optional stack trace and parameters.
  Future<void> reportError(
    dynamic exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? params,
    bool fatal = false,
  });

  /// Reports a Flutter error with optional parameters.
  Future<void> reportFlutterError(
    FlutterErrorDetails details, {
    bool fatal = false,
  });

  /// Reports a message with optional parameters.
  Future<void> reportMessage(
    String message, {
    Map<String, dynamic>? params,
    LogLevel? level = LogLevel.info,
  });

  /// Starts a trace with a specific name and operation.
  Future<Trace> startTrace(
    String name,
    String operation, {
    LogLevel? level = LogLevel.info,
  });
}

/// The base interface for a Telemetry Trace. The trace is responsible for
/// tracking the duration of an operation, and reporting metrics and attributes.
abstract class Trace {
  /// Stops or finalizes the trace.
  Future<void> stop();

  /// Sets a metric with a specific name and value.
  void setMetric(String name, int value);

  /// Gets a metric with a specific name.
  int getMetric(String name);

  /// Sets an attribute with a specific name and value.
  void setAttributes(Map<String, String> attributes);

  /// Gets all attributes set so far in the trace.
  Map<String, String> getAttributes();

  /// Starts a child trace with a specific name and operation.
  Future<Trace> startChild(
    String name,
    String operation, {
    LogLevel? level = LogLevel.info,
  });
}
