library;

import 'package:flutter/material.dart' hide runApp;
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

import 'shell.dart';

void runWidgetBook({
  required FeaturesBuilder features,
  ThemeData? lightTheme,
  ThemeData? darkTheme,
}) {
  runApp(
    features: features,
    plugins: PluginDescriptor(
      content: DefaultContentPlugin(provider: NoOpContentProvider()),
      env: DefaultEnvPlugin(),
    ),
    platformWidgetBuilder: defaultPlatformWidgetBuilder.copyWith(
      appBuilder: (platform) => WidgetBookShell(
        features: platform.features,
        lightTheme: lightTheme,
        darkTheme: darkTheme,
      ),
    ),
  );
}
