import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// The default implementation for an Analytics Plugin.
final class AnalyticsPlugin extends Plugin
    with PreloadedPlugin, InitOncePlugin
    implements AnalyticsProvider {
  /// The list of providers for the plugin.
  final List<AnalyticsProvider> providers;

  @override
  String get description => 'Analytics Plugin';

  @override
  List<NavigatorObserver> get observers =>
      providers.expand((provider) => provider.observers).toList();

  /// Creates a new AnalyticsPlugin.
  AnalyticsPlugin({required this.providers})
      : super(
          name: 'vyuh.plugin.analytics',
          title: 'Analytics Plugin',
        );

  @override
  Future<void> initOnce() {
    return Future.wait(providers.map((e) => e.init()));
  }

  @override
  Future<void> disposeOnce() {
    return Future.wait(providers.map((e) => e.dispose()));
  }

  @override
  Future<void> reportEvent(String name, {Map<String, dynamic>? params}) {
    final futures =
        providers.map((provider) => provider.reportEvent(name, params: params));

    return Future.wait(futures);
  }

  @override
  Future<void> identifyUser(String userId, {Map<String, dynamic>? traits}) {
    final futures = providers.map(
      (provider) => provider.identifyUser(userId, traits: traits),
    );
    return Future.wait(futures);
  }

  @override
  Future<void> resetUser() {
    final futures = providers.map((provider) => provider.resetUser());
    return Future.wait(futures);
  }
}
