import 'package:vyuh_core/plugin/content/noop_content_plugin.dart';
import 'package:vyuh_core/plugin/di/di_plugin.dart';
import 'package:vyuh_core/plugin/di/plugin_di_get_it.dart';
import 'package:vyuh_core/plugin/plugin.dart';

import 'analytics/analytics_plugin.dart';
import 'analytics/noop_analytics_provider.dart';
import 'auth/anonymous_auth_plugin.dart';
import 'auth/auth_plugin.dart';
import 'content/content_plugin.dart';
import 'navigation/default_navigation_plugin.dart';
import 'navigation/navigation.dart';
import 'network/http_network_plugin.dart';
import 'network/network_plugin.dart';

final class PluginDescriptor {
  final Set<Plugin> _plugins = {};

  List<Plugin> get plugins => List.unmodifiable(_plugins);

  PluginDescriptor({
    required final DIPlugin di,
    required final ContentPlugin content,
    required final AnalyticsPlugin analytics,
    required final NetworkPlugin network,
    required final AuthPlugin auth,
    required final NavigationPlugin navigation,
    final List<Plugin>? others,
  }) {
    _plugins.addAll([
      di,
      content,
      analytics,
      network,
      auth,
      navigation,
      navigation,
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
  );
}
