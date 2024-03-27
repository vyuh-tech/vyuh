import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as g;
import 'package:vyuh_core/vyuh_core.dart';

late final VyuhPlatform vyuh;

abstract class VyuhPlatform {
  final List<FeatureDescriptor> features;
  final List<Plugin> plugins;
  final PlatformWidgetBuilder widgetBuilder;

  GlobalKey<NavigatorState> get rootNavigatorKey;

  g.GoRouter get router;

  SystemInitTracker get tracker;

  Future<void>? featureReady(String featureName);

  @protected
  static const preloadedPlugins = [
    PluginType.analytics,
  ];

  @protected
  static const requiredPlugins = [
    PluginType.content,
    PluginType.di,
    PluginType.analytics,
    PluginType.network,
    // PluginType.storage,
  ];

  VyuhPlatform({
    required this.features,
    required this.plugins,
    required this.widgetBuilder,
  });

  FutureOr<void> run();

  Future<void> initPlugins();

  Future<void> initFeatures();

  Plugin? getPlugin(PluginType type);
}

extension NamedPlugins on VyuhPlatform {
  ContentPlugin get content => ensurePlugin<ContentPlugin>(PluginType.content);

  DIPlugin get di => ensurePlugin<DIPlugin>(PluginType.di);

  LoggerPlugin? get log =>
      ensurePlugin<LoggerPlugin?>(PluginType.logger, mustExist: false);

  AnalyticsPlugin get analytics =>
      ensurePlugin<AnalyticsPlugin>(PluginType.analytics);

  NetworkPlugin get network => ensurePlugin<NetworkPlugin>(PluginType.network);

  T ensurePlugin<T>(PluginType type, {bool mustExist = true}) {
    final plugin = getPlugin(type) as T;

    if (mustExist) {
      assert(plugin != null, '$T is not available in your plugins');
    }

    return plugin;
  }
}
