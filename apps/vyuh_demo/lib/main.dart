import 'package:feature_food/feature_food.dart' as food;
import 'package:feature_misc/feature_misc.dart' as misc;
import 'package:feature_puzzles/feature_puzzles.dart' as puzzles;
import 'package:feature_sample/feature_sample.dart' as sample;
import 'package:feature_sample/features/feature_launcher.dart';
import 'package:feature_tmdb/feature_tmdb.dart' as tmdb;
import 'package:feature_unsplash/feature_unsplash.dart' as unsplash;
import 'package:feature_wonderous/feature_wonderous.dart' as wonderous;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sanity_client/sanity_client.dart';
import 'package:vyuh_core/plugin/plugin_descriptor.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_auth/vyuh_feature_auth.dart' as auth;
import 'package:vyuh_feature_developer/vyuh_feature_developer.dart'
    as developer;
import 'package:vyuh_feature_onboarding/vyuh_feature_onboarding.dart'
    as onboarding;
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;
import 'package:vyuh_plugin_content_provider_sanity/vyuh_plugin_content_provider_sanity.dart';

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
    initialLocation: '/tmdb',
    plugins: _getPlugins(),
    features: () => [
      system.feature,
      developer.feature,
      sample.featureLauncher(entryPoints),
      sample.featureCounter,
      sample.featureSettings,
      tmdb.feature,
      food.feature,
      wonderous.feature,
      puzzles.feature,
      misc.feature,
      unsplash.feature,
      onboarding.feature,
      auth.feature(),
    ],
    platformWidgetBuilder:
        vc.defaultPlatformWidgetBuilder.copyWith(appBuilder: (platform) {
      return Observer(
        builder: (_) {
          var mode = platform.di.get<system.ThemeService>().currentMode.value;

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

_getPlugins() {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure all imperatively navigated URLs are shown in the URL bar
  vc.DefaultNavigationPlugin.enableURLReflectsImperativeAPIs();
  vc.DefaultNavigationPlugin.usePathStrategy();

  return PluginDescriptor(
      content: DefaultContentPlugin(
        provider: SanityContentProvider.withConfig(
          config: SanityConfig(
            projectId: '8b76lu9s',
            dataset: 'production',
            perspective: Perspective.previewDrafts,
            useCdn: false,
            token:
                'skt2tSTitRob9TonNNubWg09bg0dACmwE0zHxSePlJisRuF1mWJOvgg3ZF68CAWrqtSIOzewbc56dGavACyznDTsjm30ws874WoSH3E5wPMFrqVW8C0Hc0pJGzpYQiehfL9GTRrIyoO3y2aBQIxHpegGspzxAevZcchleelaH5uM6LAnOJT1',
          ),
          cacheDuration: const Duration(seconds: 5),
        ),
      ),
      env: vc.DefaultEnvPlugin(),
      others: [
        vc.ConsoleLoggerPlugin(),
      ]);
}
