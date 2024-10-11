import 'dart:async';

import 'package:collection/collection.dart';
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

  /// Creates a new AnalyticsPlugin.
  AnalyticsPlugin({required this.providers})
      : super(
          name: 'vyuh.plugin.analytics',
          title: 'Analytics Plugin',
        );

  @override
  Future<void> initOnce() async {
    await Future.wait(providers.map((e) => e.init()));
  }

  @override
  Future<void> reportEvent(String name, {Map<String, dynamic>? params}) {
    final futures =
        providers.map((provider) => provider.reportEvent(name, params: params));

    return Future.wait(futures);
  }

  @override
  List<NavigatorObserver> get observers =>
      providers.expand((element) => element.observers).toList(growable: false);
}
