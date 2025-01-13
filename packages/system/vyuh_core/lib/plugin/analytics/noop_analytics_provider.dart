import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// A no-op implementation of [AnalyticsProvider].
final class NoOpAnalyticsProvider implements AnalyticsProvider {
  @override
  String get name => 'vyuh.plugin.analytics.provider.noop';

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
  Future<void> reportEvent(String name, {Map<String, dynamic>? params}) async {}

  @override
  Future<void> identifyUser(String userId,
      {Map<String, dynamic>? traits}) async {}

  @override
  Future<void> resetUser() async {}

  @override
  List<NavigatorObserver> get observers => [];
}
