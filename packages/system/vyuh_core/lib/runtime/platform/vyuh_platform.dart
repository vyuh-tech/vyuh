import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// The platform interface for Vyuh. This tracks the instance of the platform and can be
/// used to access various aspects of the framework.
late final VyuhPlatform vyuh;

/// The builder function that creates a set of features.
typedef FeaturesBuilder = FutureOr<List<FeatureDescriptor>> Function();

/// The base class for the Vyuh Platform. This class is responsible for initializing the
/// platform and managing the lifecycle of the platform.
abstract class VyuhPlatform {
  /// The builder function that creates a set of features.
  final FeaturesBuilder featuresBuilder;

  /// The list of plugins that are available to the platform.
  final List<Plugin> plugins;

  /// The builder function that creates the various widgets for the platform.
  final PlatformWidgetBuilder widgetBuilder;

  /// The key for the root navigator. This is plugged into the router plugin.
  GlobalKey<NavigatorState> get rootNavigatorKey;

  /// The tracker for the system initialization.
  SystemInitTracker get tracker;

  /// Tracks the readiness of a feature, given its name.
  Future<void>? featureReady(String featureName);

  /// The list of features that are available to the platform.
  List<FeatureDescriptor> get features;

  /// The list of plugins that are required for the platform to function correctly.
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

  /// Creates a new instance of the platform.
  VyuhPlatform({
    required this.featuresBuilder,
    required this.plugins,
    required this.widgetBuilder,
  });

  /// Initializes the platform. This is called internally by the platform and should not be invoked directly.
  FutureOr<void> run();

  /// Initializes the plugins for the platform. Called internally by the platform and should not be invoked directly.
  Future<void> initPlugins(AnalyticsTrace parentTrace);

  /// Initializes the features for the platform. Called internally by the platform and should not be invoked directly.
  Future<void> initFeatures(AnalyticsTrace parentTrace);

  /// Used to get the specific plugin instance for the given type.
  Plugin? getPlugin(PluginType type);
}

/// An extension to access the named plugins.
extension NamedPlugins on VyuhPlatform {
  /// The content plugin.
  ContentPlugin get content => ensurePlugin<ContentPlugin>(PluginType.content);

  /// The dependency injection plugin.
  DIPlugin get di => ensurePlugin<DIPlugin>(PluginType.di);

  /// The logger plugin.
  LoggerPlugin? get log =>
      ensurePlugin<LoggerPlugin?>(PluginType.logger, mustExist: false);

  /// The analytics plugin.
  AnalyticsPlugin get analytics =>
      ensurePlugin<AnalyticsPlugin>(PluginType.analytics);

  /// The network plugin.
  NetworkPlugin get network => ensurePlugin<NetworkPlugin>(PluginType.network);

  /// The authentication plugin.
  AuthPlugin get auth => ensurePlugin<AuthPlugin>(PluginType.auth);

  /// The navigation plugin.
  NavigationPlugin get router =>
      ensurePlugin<NavigationPlugin>(PluginType.navigation);

  /// The feature flag plugin.
  FeatureFlagPlugin? get featureFlag =>
      ensurePlugin<FeatureFlagPlugin?>(PluginType.featureFlag,
          mustExist: false);

  /// A safe way to get the plugin instance.
  T ensurePlugin<T>(PluginType type, {bool mustExist = true}) {
    final plugin = getPlugin(type) as T;

    if (mustExist) {
      assert(plugin != null, '$T is not available in your plugins');
    }

    return plugin;
  }
}
