import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_developer/components/standard_plugin_view.dart';

extension WidgetBuilder on Plugin {
  Widget build(BuildContext context) {
    switch (pluginType) {
      case PluginType.analytics:
        final analytics = this as AnalyticsPlugin;
        return _AnalyticsPluginView(analytics: analytics);
      case PluginType.content:
        final content = this as ContentPlugin;
        return _ContentPluginView(content: content);
      default:
        return ListTile(
          title: StandardPluginView(plugin: this),
        );
    }
  }
}

class _ContentPluginView extends StatelessWidget {
  final ContentPlugin content;

  const _ContentPluginView({required this.content});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.push('/developer/plugins/content');
      },
      title: StandardPluginView(plugin: content),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class _AnalyticsPluginView extends StatelessWidget {
  const _AnalyticsPluginView({
    required this.analytics,
  });

  final AnalyticsPlugin analytics;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.push('/developer/plugins/analytics');
      },
      title: StandardPluginView(plugin: analytics),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
