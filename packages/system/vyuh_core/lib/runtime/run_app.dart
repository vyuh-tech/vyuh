import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart' as g;
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'platform/default_platform.dart';
part 'platform/framework_init_view.dart';
part 'platform/lazy_feature_manager.dart';
part 'platform/platform_init_tracker.dart';
part 'vyuh_binding.dart';

/// A builder that returns lazy feature descriptors.
typedef LazyFeaturesBuilder = List<LazyFeatureDescriptor> Function();

/// The main entry point to kick off the Vyuh Application.
/// This function should be called from the main function of the application.
/// It initializes the Vyuh Platform and runs the application with given features and plugins.
///
/// * `features`: A builder function that returns a list of [FeatureDescriptor] objects. These are loaded eagerly at startup.
/// * `lazyFeatures`: Optional. A builder function that returns a list of [LazyFeatureDescriptor] objects. These are loaded on-demand when their routes are first navigated to, enabling web code splitting via Dart's `deferred as` imports.
/// * `plugins`: Optional. A [PluginDescriptor] object that specifies the plugins to be used. If not provided, defaults to [PluginDescriptor.system].
/// * `platformWidgetBuilder`: Optional. A builder function that returns a platform-specific widget. If not provided, defaults to [defaultPlatformWidgetBuilder].
/// * `initialLocation`:  Optional. The initial location to open in the app.
void runApp({
  required FeaturesBuilder features,
  LazyFeaturesBuilder? lazyFeatures,
  PluginDescriptor? plugins,
  PlatformWidgetBuilder? platformWidgetBuilder,
  String? initialLocation,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  final widgetBuilder = platformWidgetBuilder ?? PlatformWidgetBuilder.system;

  vyuh = _DefaultVyuhPlatform(
    featuresBuilder: features,
    lazyFeaturesBuilder: lazyFeatures,
    pluginDescriptor: plugins ?? PluginDescriptor.system,
    widgetBuilder: widgetBuilder,
    initialLocation: initialLocation,
  );

  vyuh.run();
}
