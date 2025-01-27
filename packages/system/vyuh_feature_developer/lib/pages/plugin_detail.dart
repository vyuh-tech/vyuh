import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_developer/components/standard_plugin_view.dart';

/// Extension to build ListTile widget of Plugin instances
///
extension WidgetBuilder on Plugin {
  /// Builds a ListTile widget of the plugin.
  ///
  Widget build(BuildContext context) {
    switch (this) {
      case AnalyticsPlugin() || ContentPlugin() || TelemetryPlugin():
        return _PluginWithDetailsItem(plugin: this);
      default:
        return ListTile(
          leading: Icon(icon),
          title: StandardPluginItem(plugin: this),
        );
    }
  }

  /// Returns the icon for the plugin.
  ///
  IconData get icon {
    switch (this) {
      case AnalyticsPlugin():
        return Icons.show_chart;
      case TelemetryPlugin():
        return Icons.sensors;
      case ContentPlugin():
        return Icons.category;
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
