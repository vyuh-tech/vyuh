import 'package:collection/collection.dart';
import 'package:vyuh_core/plugin/auth/anonymous_auth_plugin.dart';
import 'package:vyuh_core/plugin/env/noop_env_plugin.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// A descriptor for configuring the plugin system in a Vyuh application.
/// 
/// The [PluginDescriptor] manages the registration and initialization of all plugins
/// in the application. It ensures that plugins are loaded in the correct order and
/// provides type-safe access to plugin instances.
/// 
/// Plugins are organized into several categories:
/// - Core System Plugins:
///   - [DIPlugin]: Dependency injection
///   - [ContentPlugin]: Content management
///   - [AnalyticsPlugin]: User analytics
///   - [TelemetryPlugin]: Application telemetry
///   - [NetworkPlugin]: Network communication
///   - [AuthPlugin]: Authentication
///   - [NavigationPlugin]: Routing and navigation
///   - [EnvPlugin]: Environment configuration
///   - [EventPlugin]: Event system
///   - [StoragePlugin]: Data persistence
/// - Custom Plugins: Additional plugins via [others]
/// 
/// Each plugin type has a default implementation that is used if not explicitly
/// provided. Custom implementations can be provided for any plugin type.
/// 
/// Example:
/// ```dart
/// final plugins = PluginDescriptor(
///   analytics: MyCustomAnalyticsPlugin(),
///   auth: MyCustomAuthPlugin(),
///   others: [MyCustomPlugin()],
/// );
/// ```
/// 
/// The initialization order of plugins is managed automatically based on their
/// dependencies. Core system plugins are initialized first, followed by custom
/// plugins in the order they are provided.
final class PluginDescriptor {
  final Set<Plugin> _plugins = {};

  List<Plugin> get plugins => List.unmodifiable(_plugins);

  PluginDescriptor({
    final DIPlugin? di,
    final ContentPlugin? content,
    final AnalyticsPlugin? analytics,
    final TelemetryPlugin? telemetry,
    final NetworkPlugin? network,
    final AuthPlugin? auth,
    final NavigationPlugin? navigation,
    final EnvPlugin? env,
    final EventPlugin? event,
    final StoragePlugin? storage,
    final List<Plugin>? others,
  }) {
    final otherPlugins = others ?? <Plugin>[];
    assert(() {
      for (final plugin in otherPlugins) {
        if (plugin is DIPlugin ||
            plugin is ContentPlugin ||
            plugin is AnalyticsPlugin ||
            plugin is TelemetryPlugin ||
            plugin is NetworkPlugin ||
            plugin is AuthPlugin ||
            plugin is NavigationPlugin ||
            plugin is EventPlugin ||
            plugin is StoragePlugin ||
            plugin is EnvPlugin) {
          return false;
        }
      }
      return true;
    }(),
        'Other Plugins should not contain an instance of ${defaultPluginTypes.join(' | ')}');

    _plugins.addAll([
      di ?? defaultPlugins.get<DIPlugin>(),
      content ?? defaultPlugins.get<ContentPlugin>(),
      analytics ?? defaultPlugins.get<AnalyticsPlugin>(),
      telemetry ?? defaultPlugins.get<TelemetryPlugin>(),
      network ?? defaultPlugins.get<NetworkPlugin>(),
      auth ?? defaultPlugins.get<AuthPlugin>(),
      navigation ?? defaultPlugins.get<NavigationPlugin>(),
      event ?? defaultPlugins.get<EventPlugin>(),
      env ?? defaultPlugins.get<EnvPlugin>(),
    ].nonNulls);

    _plugins.addAll(others ?? <Plugin>[]);
  }

  static final defaultPluginTypes = [
    DIPlugin,
    ContentPlugin,
    AnalyticsPlugin,
    TelemetryPlugin,
    NetworkPlugin,
    AuthPlugin,
    NavigationPlugin,
    EnvPlugin,
    EventPlugin,
  ];

  static final defaultPlugins = PluginDescriptor(
    di: GetItDIPlugin(),
    content: NoOpContentPlugin(),
    analytics: AnalyticsPlugin(providers: [NoOpAnalyticsProvider()]),
    telemetry: TelemetryPlugin(providers: [NoOpTelemetryProvider()]),
    network: HttpNetworkPlugin(),
    auth: UnknownAuthPlugin(),
    navigation: DefaultNavigationPlugin(),
    env: NoOpEnvPlugin(),
    event: DefaultEventPlugin(),
  );

  Plugin? get<T>() {
    return _plugins.firstWhereOrNull((element) => element is T);
  }
}
