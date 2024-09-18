import 'package:flutter/material.dart';
import 'package:vyuh_core/plugin/storage_plugin.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_developer/components/standard_plugin_view.dart';

extension WidgetBuilder on Plugin {
  Widget build(BuildContext context) {
    switch (this) {
      case AnalyticsPlugin() || ContentPlugin():
        return _PluginWithDetailsItem(plugin: this);
      default:
        return ListTile(
          leading: Icon(icon),
          title: StandardPluginItem(plugin: this),
        );
    }
  }

  IconData get icon {
    switch (this) {
      case AnalyticsPlugin():
        return Icons.show_chart;
      case ContentPlugin():
        return Icons.category;
      case LoggerPlugin():
        return Icons.line_style;
      case DIPlugin():
        return Icons.insert_link;
      case NetworkPlugin():
        return Icons.network_check;
      case StoragePlugin():
        return Icons.data_object;
      case SecureStoragePlugin():
        return Icons.dataset;
      case FeatureFlagPlugin():
        return Icons.flag;
      case AuthPlugin():
        return Icons.account_circle;
      case NavigationPlugin():
        return Icons.navigation_outlined;
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
      leading: Icon(plugin.icon),
      onTap: () {
        vyuh.router.push('/developer/plugins/${plugin.name}');
      },
      title: StandardPluginItem(plugin: plugin),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
