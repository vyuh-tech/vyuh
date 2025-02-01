part of 'run_app.dart';

final class VyuhBinding {
  VyuhBinding._();

  static final instance = VyuhBinding._();

  late final PluginDescriptor _pluginDescriptor;
  List<Plugin> get plugins => _pluginDescriptor.plugins;

  late final PlatformWidgetBuilder widgetBuilder;

  late final ExtensionBuilder _extensionBuilder;

  late final Future<void> widgetReady;

  bool _initialized = false;

  /// Purely meant to be called with running Vyuh in widget-mode, using `VyuhContentWidget`.
  /// There is a convenience API inside `vyuh_extension_content` to make this easier.
  /// Use the `VyuhContentBinding.init()` instead.
  ///
  /// Make sure to call this before calling Flutter's `runApp()`.
  ///
  /// !!! NOTE !!!
  /// ============
  /// DO NOT call this when using the Vyuh framework directly.
  void widgetInit({
    PluginDescriptor? plugins,
    PlatformWidgetBuilder? widgetBuilder,
    required ExtensionBuilder extensionBuilder,
    required List<ExtensionDescriptor> extensionDescriptors,
    Future<void> Function(VyuhBinding)? onReady,
  }) async {
    if (_initialized) {
      return;
    }

    this.widgetBuilder = widgetBuilder ?? PlatformWidgetBuilder.system;

    _pluginDescriptor = plugins ?? PluginDescriptor.system;
    final effectivePlugins = _pluginDescriptor.plugins;

    _extensionBuilder = extensionBuilder;

    // Invoke the init inline
    widgetReady = Future(() async {
      // Cleanup
      final disposeFns = effectivePlugins.map((e) => e.dispose());
      await Future.wait(disposeFns, eagerError: true);

      // Init
      for (final plugin in effectivePlugins) {
        await plugin.init();
      }

      // Time to associate the ContentPlugin with the ContentExtensionBuilder. This keeps
      // track of the type registry and helps in building ContentItems
      await _extensionBuilder.init(extensionDescriptors);
      content.attach(_extensionBuilder);

      await onReady?.call(VyuhBinding.instance);
    });

    _initialized = true;
  }

  Future<void> _appInit(
      {PluginDescriptor? plugins, PlatformWidgetBuilder? widgetBuilder}) async {
    if (_initialized) {
      return;
    }

    this.widgetBuilder = widgetBuilder ?? PlatformWidgetBuilder.system;

    _pluginDescriptor = plugins ?? PluginDescriptor.system;
    final effectivePlugins = _pluginDescriptor.plugins;

    final preLoadedPlugins = effectivePlugins.whereType<PreloadedPlugin>();

    for (final plugin in preLoadedPlugins) {
      await plugin.init();
    }

    _initialized = true;
  }

  T? get<T extends Plugin>() => _pluginDescriptor.get<T>();
}

extension NamedBindings on VyuhBinding {
  /// The content plugin, responsible for managing content-related operations.
  ContentPlugin get content => _pluginDescriptor.get<ContentPlugin>()!;

  /// The dependency injection plugin, providing dependency injection services.
  DIPlugin get di => _pluginDescriptor.get<DIPlugin>()!;

  /// The analytics plugin, for tracking and reporting analytics data.
  AnalyticsPlugin get analytics => _pluginDescriptor.get<AnalyticsPlugin>()!;

  /// The telemetry plugin, used for monitoring and logging telemetry information.
  TelemetryPlugin get telemetry => _pluginDescriptor.get<TelemetryPlugin>()!;

  /// The network plugin, for handling network requests and communication.
  NetworkPlugin get network => _pluginDescriptor.get<NetworkPlugin>()!;

  /// The feature flag plugin, used for managing and toggling feature flags.
  /// Can be null if the plugin is not registered.
  FeatureFlagPlugin? get featureFlag =>
      _pluginDescriptor.get<FeatureFlagPlugin>();

  /// The environment plugin, providing access to platform-specific environment settings.
  EnvPlugin get env => _pluginDescriptor.get<EnvPlugin>()!;

  /// The event plugin, for managing and emitting events within the platform.
  EventPlugin get event => _pluginDescriptor.get<EventPlugin>()!;
}
