import 'package:feature_sample/feature_sample.dart' as sample;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_feature_developer/vyuh_feature_developer.dart'
    as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  vc.runApp(
    initialLocation: '/',
    features: [
      developer.feature,
      sample.featureLauncher,
      sample.featureCounter,
    ],
    plugins: [
      vc.ConsoleLoggerPlugin(),
    ],
    platformWidgetBuilder:
        vc.defaultPlatformWidgetBuilder.copyWith(appBuilder: (platform) {
      return Observer(
        builder: (_) {
          var mode = platform.di.get<vc.ThemeService>().currentMode.value;

          return MaterialApp.router(
            title: 'Vyuh Demo',
            themeMode: mode,
            theme: ThemeData.from(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.deepPurple,
                  brightness: Brightness.light,
                )),
            darkTheme: ThemeData.from(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.deepPurpleAccent,
                  brightness: Brightness.dark,
                )),
            routerConfig: platform.router,
          );
        },
      );
    }),
  );
}
