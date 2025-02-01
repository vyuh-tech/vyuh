library;

import 'package:flutter/material.dart' hide runApp;
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

import 'shell.dart';

/// Runs the Widgetbook application for previewing Vyuh content and components.
///
/// This function sets up and launches a Widgetbook instance, allowing developers
/// to preview and interact with their Vyuh content types and layouts in isolation.
///
/// Parameters:
/// - [features]: A function that returns a list of Feature objects to be displayed in the Widgetbook.
/// - [lightTheme]: Optional custom light theme for the Widgetbook. If not provided, a default theme will be used.
/// - [darkTheme]: Optional custom dark theme for the Widgetbook. If not provided, a default theme will be used.
///
/// Example usage:
/// ```dart
/// void main() {
///   runWidgetBook(
///     features: () => [
///       myFeature1,
///       myFeature2,
///       // Add more features as needed
///     ],
///     lightTheme: MyAppTheme.light,
///     darkTheme: MyAppTheme.dark,
///   );
/// }
/// ```
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
    platformWidgetBuilder: PlatformWidgetBuilder.system.copyWith(
      appBuilder: (platform) => WidgetBookShell(
        features: platform.features,
        lightTheme: lightTheme,
        darkTheme: darkTheme,
      ),
    ),
  );
}
