import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'platform/default_platform.dart';
import 'platform/framework_init_widget.dart';

class VyuhPlatformScope extends InheritedWidget {
  final VyuhPlatform platform;

  const VyuhPlatformScope({
    super.key,
    required this.platform,
    required super.child,
  });

  static VyuhPlatform of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<VyuhPlatformScope>()!
        .platform;
  }

  @override
  bool updateShouldNotify(VyuhPlatformScope oldWidget) =>
      platform != oldWidget.platform;
}

/// A widget that provides a [VyuhPlatform] to its children.
/// Used to access the current platform instance.
extension VyuhContextExtensions on BuildContext {
  VyuhPlatform get vyuh => VyuhPlatformScope.of(this);
}

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

  /// Unique identifier for this VyuhWidget instance.
  /// This is required to support multiple VyuhWidget instances in the same app.
  /// When using runApp(), this is automatically set to [VyuhWidget.mainAppId].
  final String id;

  /// The ID used for the main Vyuh app when using runApp().
  static const mainAppId = '_vyuh_main_app_';

  const VyuhWidget({
    super.key,
    required this.id,
    required this.features,
    this.plugins,
    this.widgetBuilder,
    this.initialLocation,
  });

  /// Creates a VyuhWidget instance for use as the main app.
  /// This is used internally by runApp() and should not be used directly.
  const VyuhWidget.mainApp({
    super.key,
    required this.features,
    this.plugins,
    this.widgetBuilder,
    this.initialLocation,
  }) : id = mainAppId;

  @override
  State<VyuhWidget> createState() => _VyuhWidgetState();
}

class _VyuhWidgetState extends State<VyuhWidget> {
  late final VyuhPlatform _platform;

  @override
  void initState() {
    super.initState();
    _initVyuh();
  }

  void _initVyuh() {
    // Create platform instance
    _platform = DefaultVyuhPlatform(
      featuresBuilder: widget.features,
      pluginDescriptor: widget.plugins ?? PluginDescriptor.defaultPlugins,
      widgetBuilder: widget.widgetBuilder ?? defaultPlatformWidgetBuilder,
      initialLocation: widget.initialLocation,
    );

    // Register platform with its ID
    VyuhPlatform.register(widget.id, _platform);

    if (widget.id == VyuhWidget.mainAppId) {
      // Set default instance, which is applicable when running in App mode
      vyuh = _platform;
    }
  }

  @override
  void dispose() {
    // Unregister platform
    VyuhPlatform.remove(widget.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VyuhPlatformScope(
      platform: _platform,
      child: FrameworkInitWidget(platform: _platform),
    );
  }
}
