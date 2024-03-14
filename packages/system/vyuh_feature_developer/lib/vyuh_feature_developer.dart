library vyuh_feature_developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';
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
        ]),
  ],
);
