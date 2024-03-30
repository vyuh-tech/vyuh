library vyuh_feature_developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content_extension_descriptor.dart';
import 'package:vyuh_feature_developer/analytics_plugin_details.dart';
import 'package:vyuh_feature_developer/content_extension_detail.dart';
import 'package:vyuh_feature_developer/content_plugin_details.dart';
import 'package:vyuh_feature_developer/feature_detail.dart';
import 'package:vyuh_feature_developer/plugin_and_feature_list.dart';

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

          return state.fullPath;
        },
        routes: [
          GoRoute(
            path: 'list',
            builder: (context, state) => const PluginAndFeatureList(),
          ),
          GoRoute(
            path: 'detail',
            builder: (context, state) =>
                FeatureDetail(feature: state.extra as FeatureDescriptor),
          ),
          GoRoute(
            path: 'plugins/content',
            builder: (context, state) => ContentPluginDetailsView(
                plugin: vyuh.plugins.firstWhere(
                        (element) => element.pluginType == PluginType.content)
                    as ContentPlugin),
          ),
          GoRoute(
            path: 'plugins/analytics',
            builder: (context, state) => AnalyticsPluginDetailsView(
                plugin: vyuh.plugins.firstWhere(
                        (element) => element.pluginType == PluginType.analytics)
                    as AnalyticsPlugin),
          ),
          GoRoute(
            path: 'extensions/content',
            builder: (context, state) => ContentExtensionDetailsView(
                extension: state.extra as ContentExtensionDescriptor),
          ),
        ]),
  ],
);
