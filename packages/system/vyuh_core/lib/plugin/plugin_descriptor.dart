import 'package:vyuh_core/plugin/auth/anonymous_auth_plugin.dart';
import 'package:vyuh_core/plugin/env/noop_env_plugin.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class PluginDescriptor {
  final Set<Plugin> _plugins = {};

  List<Plugin> get plugins => List.unmodifiable(_plugins);

  PluginDescriptor({
    final DIPlugin? di,
    final ContentPlugin? content,
    final NetworkPlugin? network,
    final AuthPlugin? auth,
    final NavigationPlugin? navigation,
    final EnvPlugin? env,
    final AnalyticsPlugin? analytics,
    final TelemetryPlugin? telemetry,
    final EventPlugin? event,
    final List<Plugin>? others,
  }) {
    _plugins.addAll([
      di ?? defaultPlugins.get<DIPlugin>(),
      content ?? defaultPlugins.get<ContentPlugin>(),
      network ?? defaultPlugins.get<NetworkPlugin>(),
      auth ?? defaultPlugins.get<AuthPlugin>(),
      navigation ?? defaultPlugins.get<NavigationPlugin>(),
      event ?? defaultPlugins.get<EventPlugin>(),
      env ?? defaultPlugins.get<EnvPlugin>(),
      analytics ?? defaultPlugins.get<AnalyticsPlugin>(),
      telemetry ?? defaultPlugins.get<TelemetryPlugin>(),
    ]);

    _plugins.addAll(others ?? []);
  }

  static final defaultPlugins = PluginDescriptor(
      di: GetItDIPlugin(),
      content: NoOpContentPlugin(),
      network: HttpNetworkPlugin(),
      auth: UnknownAuthPlugin(),
      navigation: DefaultNavigationPlugin(),
      env: NoOpEnvPlugin(),
      event: DefaultEventPlugin(),
      analytics: AnalyticsPlugin(providers: [NoOpAnalyticsProvider()]),
      telemetry: TelemetryPlugin(providers: [NoOpTelemetryProvider()]));

  Plugin get<T>() {
    return _plugins.firstWhere((element) => element is T);
  }
}
