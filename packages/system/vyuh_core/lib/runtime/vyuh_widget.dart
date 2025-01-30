import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'platform/default_platform.dart';
import 'platform/framework_init_widget.dart';

/// A widget that encapsulates the Vyuh framework and can be used within a Flutter widget tree.
class VyuhWidget extends StatefulWidget {
  /// A builder function that returns a [Features] object.
  final FeaturesBuilder features;

  /// Optional. A [PluginDescriptor] object that specifies the plugins to be used.
  final PluginDescriptor? plugins;

  /// Optional. Platform-specific widget builders for customizing the UI.
  final PlatformWidgetBuilder? widgetBuilder;

  /// Optional. The initial location to open in the app.
  final String? initialLocation;

  const VyuhWidget({
    super.key,
    required this.features,
    this.plugins,
    this.widgetBuilder,
    this.initialLocation,
  });

  @override
  State<VyuhWidget> createState() => _VyuhWidgetState();
}

class _VyuhWidgetState extends State<VyuhWidget> {
  late VyuhPlatform _platform;

  @override
  void initState() {
    super.initState();
    _initVyuh();
  }

  void _initVyuh() {
    _platform = DefaultVyuhPlatform(
      featuresBuilder: widget.features,
      pluginDescriptor: widget.plugins ?? PluginDescriptor.defaultPlugins,
      widgetBuilder: widget.widgetBuilder ?? defaultPlatformWidgetBuilder,
      initialLocation: widget.initialLocation,
    );

    unawaited(_platform.run());
  }

  @override
  Widget build(BuildContext context) {
    return FrameworkInitWidget(platform: _platform);
  }
}
