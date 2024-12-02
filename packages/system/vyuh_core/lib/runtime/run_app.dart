import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart' as g;
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/plugin/plugin_descriptor.dart';
import 'package:vyuh_core/runtime/platform/events.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_core/vyuh_core.dart';

part 'platform/default_platform.dart';
part 'platform/framework_init_view.dart';
part 'platform/platform_init_tracker.dart';

/// The main entry point to kick off the Vyuh Application.
/// This function should be called from the main function of the application.
/// It initializes the Vyuh Platform and runs the application with given features and plugins.
void runApp({
  required FeaturesBuilder features,
  PluginDescriptor? plugins,
  PlatformWidgetBuilder? platformWidgetBuilder,
  String? initialLocation,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  final widgetBuilder = platformWidgetBuilder ?? defaultPlatformWidgetBuilder;

  vyuh = _DefaultVyuhPlatform(
    featuresBuilder: features,
    pluginDescriptor: plugins ?? PluginDescriptor.defaultPlugins,
    widgetBuilder: widgetBuilder,
    initialLocation: initialLocation,
  );

  vyuh.run();
}
