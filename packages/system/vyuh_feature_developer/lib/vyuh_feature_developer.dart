library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content_extension_descriptor.dart';
import 'package:vyuh_feature_developer/analytics_plugin_detail.dart';
import 'package:vyuh_feature_developer/content_extension_detail.dart';
import 'package:vyuh_feature_developer/content_plugin_detail.dart';
import 'package:vyuh_feature_developer/feature_detail.dart';
import 'package:vyuh_feature_developer/plugin_and_feature_list.dart';
import 'package:vyuh_feature_developer/telemetry_plugin_detail.dart';

final feature = FeatureDescriptor(
  name: 'developer',
  title: 'Developer Tools',
  description: 'See details of all features packaged in your app.',
  icon: Icons.code_rounded,
  routes: () => [
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
  ],
);

extension on Plugin {
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
