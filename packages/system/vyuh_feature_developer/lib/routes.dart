import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_developer/pages/analytics_plugin_detail.dart';
import 'package:vyuh_feature_developer/pages/content_plugin_detail.dart';
import 'package:vyuh_feature_developer/pages/telemetry_plugin_detail.dart';
import 'package:vyuh_feature_developer/routes.dart';

import 'pages/content_extension_detail.dart';
import 'pages/content_playground.dart';
import 'pages/feature_detail.dart';
import 'pages/plugin_and_feature_list.dart';

List<GoRoute> routes() {
  return [
    GoRoute(
        path: '/developer',
        redirect: (context, state) {
          if (state.matchedLocation == state.fullPath) {
            return '/developer/list';
          }

          return state.uri.path;
        },
        routes: [
          GoRoute(
            path: 'list',
            builder: (context, state) => const PluginAndFeatureList(),
          ),
          GoRoute(
            path: 'playground',
            builder: (context, state) => const ContentPlayground(),
          ),
          GoRoute(
            path: 'features/:name',
            builder: (context, state) => FeatureDetail(
                feature: vyuh.features.firstWhere(
                    (element) => element.name == state.pathParameters['name'])),
          ),
          GoRoute(
            path: 'plugins/:name',
            builder: (context, state) {
              final plugin = vyuh.plugins.firstWhere(
                  (element) => element.name == state.pathParameters['name']);

              return plugin.detailsView(context);
            },
          ),
          GoRoute(
            path: 'extensions/content',
            builder: (context, state) => ContentExtensionDetail(
                extension: state.extra as ContentExtensionDescriptor),
          ),
        ]),
  ];
}

extension PluginDetailsView on Plugin {
  Widget detailsView(BuildContext context) {
    final plugin = vyuh.plugins.firstWhere((element) => element == this);

    switch (this) {
      case AnalyticsPlugin():
        return AnalyticsPluginDetail(
          plugin: plugin as AnalyticsPlugin,
        );
      case TelemetryPlugin():
        return TelemetryPluginDetail(
          plugin: plugin as TelemetryPlugin,
        );
      case ContentPlugin():
        return ContentPluginDetailsView(
          plugin: plugin as ContentPlugin,
        );
      default:
        return const SizedBox();
    }
  }
}
