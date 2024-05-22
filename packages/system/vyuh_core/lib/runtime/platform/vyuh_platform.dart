import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

late final VyuhPlatform vyuh;

typedef FeaturesBuilder = FutureOr<List<FeatureDescriptor>> Function();

abstract class VyuhPlatform {
  final FeaturesBuilder featuresBuilder;
  final List<Plugin> plugins;
  final PlatformWidgetBuilder widgetBuilder;

  GlobalKey<NavigatorState> get rootNavigatorKey;

  SystemInitTracker get tracker;

  Future<void>? featureReady(String featureName);

  List<FeatureDescriptor> get features;

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
    PluginType.auth,
    PluginType.navigation,
    // PluginType.storage,
  ];

  VyuhPlatform({
    required this.featuresBuilder,
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

  AuthPlugin get auth => ensurePlugin<AuthPlugin>(PluginType.auth);

  NavigationPlugin get router =>
      ensurePlugin<NavigationPlugin>(PluginType.navigation);

  T ensurePlugin<T>(PluginType type, {bool mustExist = true}) {
    final plugin = getPlugin(type) as T;

    if (mustExist) {
      assert(plugin != null, '$T is not available in your plugins');
    }

    return plugin;
  }
}
