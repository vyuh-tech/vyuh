part of 'vyuh_platform.dart';

final class _UninitializedPlatform extends VyuhPlatform {
  @override
  Future<void>? featureReady(String featureName) {
    throw _error();
  }

  @override
  List<FeatureDescriptor> get features => throw _error();

  @override
  T? getPlugin<T extends Plugin>() {
    throw _error();
  }

  @override
  Future<void> initFeatures(Trace parentTrace) {
    throw _error();
  }

  @override
  Future<void> initPlugins(Trace parentTrace) {
    throw _error();
  }

  @override
  List<Plugin> get plugins => throw _error();

  @override
  ExtensionBuilder<ExtensionDescriptor>?
      getExtensionBuilder<T extends ExtensionDescriptor>() => _error();

  @override
  GlobalKey<NavigatorState> get rootNavigatorKey => throw _error();

  @override
  FutureOr<void> run() {
    throw _error();
  }

  @override
  SystemInitTracker get tracker => throw _error();

  @override
  PlatformWidgetBuilder get widgetBuilder => throw _error();
}

_error() =>
    StateError('''You are using an uninitialized instance of the VyuhPlatform. 
    Please call runApp() in vyuh_core to get a correct instance.
    ''');
