import 'dart:async';

import 'package:flutter/widgets.dart';

/// The base interface for an Analytics Provider. The provider is responsible for
/// reporting analytics events, errors, and messages.
abstract interface class AnalyticsProvider {
  /// The list of observers for the provider.
  /// These are added to the navigator, as part of the router setup.
  List<NavigatorObserver> get observers;

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

  /// Reports an event with a specific name and optional parameters.
  Future<void> reportEvent(String name, {Map<String, dynamic>? params});

  /// Reports an error with an optional stack trace and parameters.
  Future<void> reportError(dynamic exception,
      {StackTrace? stackTrace,
      Map<String, dynamic>? params,
      bool fatal = false});

  /// Reports a Flutter error with optional parameters.
  Future<void> reportFlutterError(FlutterErrorDetails details,
      {bool fatal = false});

  /// Reports a message with optional parameters.
  Future<void> reportMessage(String message, {Map<String, dynamic>? params});

  /// Starts a trace with a specific name and operation.
  Future<AnalyticsTrace> startTrace(String name, String operation);
}

/// The base interface for an Analytics Trace. The trace is responsible for
/// tracking the duration of an operation, and reporting metrics and attributes.
abstract class AnalyticsTrace {
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
  Future<AnalyticsTrace> startChild(String name, String operation);
}
