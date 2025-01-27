import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_feature_developer/vyuh_feature_developer.dart'
    as developer;

void main() async {
  vc.runApp(
    features: () => [
      // feature that shows all the included features in a Vyuh-enabled App
      developer.feature,
    ],
    platformWidgetBuilder:
        vc.defaultPlatformWidgetBuilder.copyWith(appBuilder: (platform) {
      return MaterialApp.router(
        title: 'Vyuh Demo',
        debugShowCheckedModeBanner: false,
        routerConfig: platform.router.instance,
      );
    }),
  );
}
