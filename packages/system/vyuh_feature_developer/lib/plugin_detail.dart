import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/plugin_types/plugin.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_developer/components/standard_plugin_view.dart';

extension WidgetBuilder on Plugin {
  Widget build(BuildContext context) {
    switch (pluginType) {
      case PluginType.analytics || PluginType.content:
        return _PluginWithDetailsItem(plugin: this);
      default:
        return ListTile(
          leading: Icon(pluginType.icon),
          title: StandardPluginItem(plugin: this),
        );
    }
  }
}

extension on PluginType {
  IconData get icon {
    switch (this) {
      case PluginType.analytics:
        return Icons.show_chart;
      case PluginType.content:
        return Icons.category;
      case PluginType.logger:
        return Icons.line_style;
      case PluginType.di:
        return Icons.insert_link;
      case PluginType.network:
        return Icons.network_check;
      case PluginType.storage:
        return Icons.data_object;
      case PluginType.secureStorage:
        return Icons.dataset;
      case PluginType.featureFlag:
        return Icons.flag;
      case PluginType.auth:
        return Icons.account_circle;
      default:
        return Icons.extension;
    }
  }
}

class _PluginWithDetailsItem extends StatelessWidget {
  final Plugin plugin;

  const _PluginWithDetailsItem({required this.plugin});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(plugin.pluginType.icon),
      onTap: () {
        context.push('/developer/plugins/${plugin.pluginType}');
      },
      title: StandardPluginItem(plugin: plugin),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
