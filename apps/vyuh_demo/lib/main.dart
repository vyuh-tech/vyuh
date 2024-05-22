import 'package:feature_sample/feature_sample.dart' as sample;
import 'package:feature_sample/features/feature_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_feature_developer/vyuh_feature_developer.dart'
    as developer;
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;

/// A set of entry points to show case the various "features" of the
/// Vyuh Framework
final entryPoints = [
  EntryPoint(
    title: 'Developer Tools',
    description: 'See details of all the features and plugins',
    path: '/developer',
    icon: Icons.account_tree,
  ),
  EntryPoint(
    title: 'Counter',
    description: 'The classic Flutter counter',
    path: '/counter',
    icon: Icons.add_circle_outlined,
  ),
  EntryPoint(
    title: 'Theme Settings',
    description: 'Switch to Light / Dark mode',
    path: '/settings',
    icon: Icons.light_mode,
  ),
];

void main() async {
  vc.runApp(
    initialLocation: '/',
    features: () => [
      developer.feature,
      sample.featureLauncher(entryPoints),
      sample.featureCounter,
      sample.featureSettings,
      system.feature,
    ],
    platformWidgetBuilder:
        vc.defaultPlatformWidgetBuilder.copyWith(appBuilder: (platform) {
      return Observer(
        builder: (_) {
          var mode = platform.di.get<vc.ThemeService>().currentMode.value;

          return MaterialApp.router(
            title: 'Vyuh Demo',
            themeMode: mode,
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            routerConfig: platform.router.instance,
          );
        },
      );
    }),
  );
}
