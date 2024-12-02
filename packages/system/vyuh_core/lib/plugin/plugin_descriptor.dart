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
    final NetworkPlugin? network,
    final AuthPlugin? auth,
    final NavigationPlugin? navigation,
    final EnvPlugin? env,
    final EventPlugin? event,
    final List<Plugin>? others,
  }) {
    _plugins.addAll([
      di ?? defaultPlugins.get<DIPlugin>(),
      content ?? defaultPlugins.get<ContentPlugin>(),
      analytics ?? defaultPlugins.get<AnalyticsPlugin>(),
      network ?? defaultPlugins.get<NetworkPlugin>(),
      auth ?? defaultPlugins.get<AuthPlugin>(),
      navigation ?? defaultPlugins.get<NavigationPlugin>(),
      event ?? defaultPlugins.get<EventPlugin>(),
      env ?? defaultPlugins.get<EnvPlugin>(),
    ]);

    _plugins.addAll(others ?? []);
  }

  static final defaultPlugins = PluginDescriptor(
    di: GetItDIPlugin(),
    content: NoOpContentPlugin(),
    analytics: AnalyticsPlugin(providers: [NoOpAnalyticsProvider()]),
    network: HttpNetworkPlugin(),
    auth: UnknownAuthPlugin(),
    navigation: DefaultNavigationPlugin(),
    env: NoOpEnvPlugin(),
    event: DefaultEventPlugin(),
  );

  Plugin get<T>() {
    return _plugins.firstWhere((element) => element is T);
  }
}
