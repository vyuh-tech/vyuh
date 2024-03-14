import 'package:feature_sample/feature_sample.dart' as sample;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_feature_developer/vyuh_feature_developer.dart'
    as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  vc.runApp(
    initialLocation: '/ad',
    features: [
      developer.feature,
      sample.feature,
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
            theme: ThemeMode.light.theme,
            darkTheme: ThemeMode.dark.theme,
            routerConfig: platform.router,
          );
        },
      );
    }),
  );
}

extension ThemeInfoProvider on ThemeMode {
  String get name => switch (this) {
        ThemeMode.system => 'System',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
      };

  ThemeData get theme => switch (this) {
        ThemeMode.system => ThemeData.fallback(useMaterial3: true),
        ThemeMode.light => ThemeData.light(useMaterial3: true),
        ThemeMode.dark => ThemeData.dark(useMaterial3: true)
      };
}
