import 'package:flutter/material.dart' as flutter;
import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// The main entry point to kick off the Vyuh Application.
/// This function should be called from the main function of the application.
/// It initializes the Vyuh Platform and runs the application with given features and plugins.
///
/// * `features`: A builder function that returns a [Features] object.  This object configures the features available in the app.
/// * `plugins`: Optional. A [PluginDescriptor] object that specifies the plugins to be used. If not provided, defaults to [PluginDescriptor.defaultPlugins].
/// * `platformWidgetBuilder`: Optional. A builder function that returns a platform-specific widget. If not provided, defaults to [defaultPlatformWidgetBuilder].
/// * `initialLocation`:  Optional. The initial location to open in the app.
void runApp({
  required FeaturesBuilder features,
  PluginDescriptor? plugins,
  PlatformWidgetBuilder? platformWidgetBuilder,
  String? initialLocation,
}) {
  WidgetsFlutterBinding.ensureInitialized();

  flutter.runApp(
    VyuhWidget.mainApp(
      features: features,
      plugins: plugins,
      widgetBuilder: platformWidgetBuilder,
      initialLocation: initialLocation,
    ),
  );
}
