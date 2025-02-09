part of 'run_app.dart';

enum _RunMode {
  app,
  widget;
}

final class VyuhBinding {
  VyuhBinding._();

  static VyuhBinding _instance = VyuhBinding._();
  static VyuhBinding get instance => _instance;

  late final _RunMode _mode;

  late final PluginDescriptor _pluginDescriptor;
  List<Plugin> get plugins => _pluginDescriptor.plugins;

  late final PlatformWidgetBuilder widgetBuilder;

  late final ExtensionBuilder _extensionBuilder;

  late final Future<void> widgetReady;

  bool _initInvoked = false;
  bool get initInvoked => _initInvoked;

  bool _initialized = false;
  bool get initialized => _initialized;

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

    _initInvoked = true;
    _mode = _RunMode.widget;

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

      await onReady?.call(VyuhBinding.instance);
    });

    _initialized = true;
  }

  Future<void> _appInit(
      {PluginDescriptor? plugins, PlatformWidgetBuilder? widgetBuilder}) async {
    if (_initialized) {
      return;
    }

    _mode = _RunMode.app;

    this.widgetBuilder = widgetBuilder ?? PlatformWidgetBuilder.system;

    _pluginDescriptor = plugins ?? PluginDescriptor.system;
    final effectivePlugins = _pluginDescriptor.plugins;

    final preLoadedPlugins = effectivePlugins.whereType<PreloadedPlugin>();

    for (final plugin in preLoadedPlugins) {
      await plugin.init();
    }

    _initialized = true;
  }

  Future<void> dispose() async {
    if (!_initialized) {
      return;
    }

    await Future.wait(_pluginDescriptor.plugins.map((p) => p.dispose()));

    if (_mode == _RunMode.widget) {
      await _extensionBuilder.dispose();
    }

    _instance = VyuhBinding._();
    _initialized = false;
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
