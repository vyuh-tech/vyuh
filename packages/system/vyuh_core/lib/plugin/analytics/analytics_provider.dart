import 'package:flutter/widgets.dart';

abstract interface class AnalyticsProvider {
  List<NavigatorObserver> get observers;
  String get name;
  String get title;
  String get description;

  Future<void> init();
  Future<void> dispose();

  Future<void> reportEvent(String name, {Map<String, dynamic>? params});
  Future<void> reportError(dynamic exception,
      {StackTrace? stackTrace,
      Map<String, dynamic>? params,
      bool fatal = false});
  Future<void> reportFlutterError(FlutterErrorDetails details,
      {bool fatal = false});
  Future<void> reportMessage(String message, {Map<String, dynamic>? params});
  AnalyticsTrace createTrace(String name);
}

abstract class AnalyticsTrace {
  Future<void> start();
  Future<void> stop();

  void setMetric(String name, int value);
  int getMetric(String name);

  void setAttributes(Map<String, String> attributes);
  Map<String, String> getAttributes();
}
