import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'uninitialized_platform.dart';

/// The platform interface for Vyuh. This tracks the instance of the platform and can be
/// used to access various aspects of the framework.
VyuhPlatform vyuh = _UninitializedPlatform();

/// Registry to manage multiple Vyuh platform instances.
class _VyuhPlatformRegistry {
  final _registry = <String, VyuhPlatform>{};

  /// Register a platform instance with a unique ID.
  /// Throws if a platform with the same ID already exists.
  VyuhPlatform register(String id, VyuhPlatform platform) {
    if (_registry.containsKey(id)) {
      throw StateError('A VyuhPlatform with ID "$id" is already registered.');
    }

    _registry[id] = platform;
    return platform;
  }

  /// Get a platform instance by ID.
  /// If id is null, returns null (caller should handle default instance).
  /// If id is provided but no platform exists, returns null.
  VyuhPlatform? get(String? id) {
    if (id == null) {
      return null;
    }

    return _registry[id];
  }

  /// Remove a platform instance by ID.
  /// Safe to call even if the platform doesn't exist.
  void remove(String id) {
    _registry.remove(id);
  }

  /// Check if a platform instance with the given ID exists.
  bool has(String id) => _registry.containsKey(id);
}

/// The builder function that creates a set of features.
typedef FeaturesBuilder = FutureOr<List<FeatureDescriptor>> Function();

/// The base class for the Vyuh Platform. This class is responsible for initializing the
/// platform and managing the lifecycle of the platform.
abstract class VyuhPlatform {
  static final _registry = _VyuhPlatformRegistry();

  /// Register a platform instance with a unique ID.
  static VyuhPlatform register(String id, VyuhPlatform platform) {
    assert(
      !_registry.has(id),
      'A VyuhPlatform with ID "$id" is already registered.',
    );

    return _registry.register(id, platform);
  }

  /// Get a platform instance by ID.
  static VyuhPlatform? get(String? id) {
    return _registry.get(id);
  }

  /// Remove a platform instance by ID.
  static void remove(String id) {
    _registry.remove(id);
  }

  /// A list of features currently registered and available on the platform.
  List<FeatureDescriptor> get features;

  /// A list of plugins available to the platform. Plugins provide extended
  /// functionalities and services to the platform.
  List<Plugin> get plugins;

  /// A builder function that creates platform-specific widgets. This allows for
  /// flexible UI customization based on the platform.
  PlatformWidgetBuilder get widgetBuilder;

  /// The root navigator key. Used by the router plugin for navigation management
  /// within the application.
  GlobalKey<NavigatorState> get rootNavigatorKey;

  /// Tracks the initialization status of the platform, including its features and plugins.
  SystemInitTracker get tracker;

  /// Verifies or waits for the specified feature to become ready.
  ///
  /// [featureName]: The name of the feature to check for readiness.
  Future<void>? featureReady(String featureName);

  /// Initializes the registered plugins for the platform. This method is internally
  /// managed and should not be called directly.
  ///
  /// [parentTrace]: A trace object for monitoring the plugin initialization process.
  Future<void> initPlugins(Trace parentTrace);

  /// Initializes the features for the platform. This method is internally managed and
  /// should not be called directly.
  ///
  /// [parentTrace]: A trace object for tracking the feature initialization process.
  Future<void> initFeatures(Trace parentTrace);

  /// Retrieves a specific plugin instance based on the requested type [T]. Returns
  /// null if no plugin of the specified type is registered. There are named extensions
  /// already available for all the standard plugins. You use this method when writing a custom plugin
  /// which needs to be exposed with a named extension. Refer to the [NamedPlugins] extension for
  /// a practical example of exposing a named reference to a plugin.
  ///
  /// Example:
  /// ```dart
  /// final networkPlugin = vyuh.getPlugin<NetworkPlugin>();
  /// if (networkPlugin != null) {
  ///   // Use the network plugin
  /// }
  /// ```
  T? getPlugin<T extends Plugin>();

  /// Gets the ExtensionBuilder given an extensionType
  ExtensionBuilder? extensionBuilder<T extends ExtensionDescriptor>();

  /// Returns an instance of the VyuhPlatform that matches the given [id].
  /// This style of invoking the vyuh platform is useful when you have multiple
  /// [VyuhWidget] instances with different ids.
  ///
  /// If [id] is null, it returns the default instance of the VyuhPlatform.
  ///
  /// Otherwise, it returns the instance of the VyuhPlatform that matches the
  /// given [id]. If no instance is found, throws a StateError.
  VyuhPlatform call(String? id) {
    if (id == null) {
      return this;
    }

    final platform = VyuhPlatform.get(id);
    if (platform == null) {
      throw StateError(
        'No VyuhPlatform found with ID "$id". Make sure to create a VyuhWidget with this ID.',
      );
    }

    return platform;
  }
}

/// Provides convenient accessors for named plugins within the Vyuh platform.
extension NamedPlugins on VyuhPlatform {
  /// The content plugin, responsible for managing content-related operations.
  ContentPlugin get content => getPlugin<ContentPlugin>()!;

  /// The dependency injection plugin, providing dependency injection services.
  DIPlugin get di => getPlugin<DIPlugin>()!;

  /// The analytics plugin, for tracking and reporting analytics data.
  AnalyticsPlugin get analytics => getPlugin<AnalyticsPlugin>()!;

  /// The telemetry plugin, used for monitoring and logging telemetry information.
  TelemetryPlugin get telemetry => getPlugin<TelemetryPlugin>()!;

  /// The network plugin, for handling network requests and communication.
  NetworkPlugin get network => getPlugin<NetworkPlugin>()!;

  /// The authentication plugin, responsible for user authentication and authorization.
  AuthPlugin get auth => getPlugin<AuthPlugin>()!;

  /// The navigation/router plugin, managing navigation within the application.
  NavigationPlugin get router => getPlugin<NavigationPlugin>()!;

  /// The feature flag plugin, used for managing and toggling feature flags.
  /// Can be null if the plugin is not registered.
  FeatureFlagPlugin? get featureFlag => getPlugin<FeatureFlagPlugin>();

  /// The environment plugin, providing access to platform-specific environment settings.
  EnvPlugin get env => getPlugin<EnvPlugin>()!;

  /// The event plugin, for managing and emitting events within the platform.
  EventPlugin get event => getPlugin<EventPlugin>()!;
}

/// Restart the platform, re-running the initialization process.
extension Restartable on VyuhPlatform {
  Future<void> restart() {
    return tracker.init();
  }
}
