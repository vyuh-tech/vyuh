import 'package:collection/collection.dart';
import 'package:vyuh_core/plugin/auth/anonymous_auth_plugin.dart';
import 'package:vyuh_core/plugin/env/noop_env_plugin.dart';
import 'package:vyuh_core/vyuh_core.dart';

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
    final LoggerPlugin? logger,
    final List<Plugin>? others,
  }) {
    final otherPlugins = others ?? [];
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
            plugin is EnvPlugin ||
            plugin is LoggerPlugin) {
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
      logger ?? defaultPlugins.get<LoggerPlugin>(),
    ].whereNot((x) => x == null).cast<Plugin>());

    _plugins.addAll(others ?? []);
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
    LoggerPlugin,
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
    logger: NoOpLoggerPlugin(),
  );

  Plugin? get<T>() {
    return _plugins.firstWhereOrNull((element) => element is T);
  }
}
