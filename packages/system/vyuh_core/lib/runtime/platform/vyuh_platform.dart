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
  FeaturesBuilder get featuresBuilder;

  /// The list of plugins that are available to the platform.
  List<Plugin> get plugins;

  /// The builder function that creates the various widgets for the platform.
  PlatformWidgetBuilder get widgetBuilder;

  /// The key for the root navigator. This is plugged into the router plugin.
  GlobalKey<NavigatorState> get rootNavigatorKey;

  /// The tracker for the system initialization.
  SystemInitTracker get tracker;

  /// Tracks the readiness of a feature, given its name.
  Future<void>? featureReady(String featureName);

  /// The list of features that are available to the platform.
  List<FeatureDescriptor> get features;

  /// Initializes the platform. This is called internally by the platform and should not be invoked directly.
  FutureOr<void> run();

  /// Initializes the plugins for the platform. Called internally by the platform and should not be invoked directly.
  Future<void> initPlugins(AnalyticsTrace parentTrace);

  /// Initializes the features for the platform. Called internally by the platform and should not be invoked directly.
  Future<void> initFeatures(AnalyticsTrace parentTrace);

  /// Used to get the specific plugin instance for the given type.
  T? getPlugin<T extends Plugin>();
}

/// An extension to access the named plugins.
extension NamedPlugins on VyuhPlatform {
  /// The content plugin.
  ContentPlugin get content => getPlugin<ContentPlugin>()!;

  /// The dependency injection plugin.
  DIPlugin get di => getPlugin<DIPlugin>()!;

  /// The logger plugin.
  LoggerPlugin? get log => getPlugin<LoggerPlugin>();

  /// The analytics plugin.
  AnalyticsPlugin get analytics => getPlugin<AnalyticsPlugin>()!;

  /// The network plugin.
  NetworkPlugin get network => getPlugin<NetworkPlugin>()!;

  /// The authentication plugin.
  AuthPlugin get auth => getPlugin<AuthPlugin>()!;

  /// The navigation plugin.
  NavigationPlugin get router => getPlugin<NavigationPlugin>()!;

  /// The feature flag plugin.
  FeatureFlagPlugin? get featureFlag => getPlugin<FeatureFlagPlugin>();

  /// The env plugin.
  EnvPlugin get env => getPlugin<EnvPlugin>()!;
}
