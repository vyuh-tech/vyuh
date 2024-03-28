import 'package:flutter/material.dart';
import 'package:vyuh_core/runtime/platform/default_platform.dart';
import 'package:vyuh_core/vyuh_core.dart';

void runApp({
  required FeaturesBuilder features,
  List<Plugin>? plugins,
  PlatformWidgetBuilder? platformWidgetBuilder,
  String? initialLocation,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  final widgetBuilder = platformWidgetBuilder ?? defaultPlatformWidgetBuilder;

  vyuh = DefaultVyuhPlatform(
    featuresBuilder: features,
    plugins: plugins ?? [],
    widgetBuilder: widgetBuilder,
    initialLocation: initialLocation,
  );

  vyuh.run();
}
