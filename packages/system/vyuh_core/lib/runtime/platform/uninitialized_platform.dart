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
      extensionBuilder<T extends ExtensionDescriptor>() => _error();

  @override
  GlobalKey<NavigatorState> get rootNavigatorKey => throw _error();

  @override
  SystemInitTracker get tracker => throw _error();

  @override
  PlatformWidgetBuilder get widgetBuilder => throw _error();

  @override
  VyuhPlatform call(String? id) => throw _error();
}

_error() =>
    StateError('''You are using an uninitialized instance of the VyuhPlatform. 
    You have to initialize the platform before using it. Please call 
    - runApp() to create a Vyuh App OR
    - create a VyuhWidget inside your Widget tree
    
    Either of these approaches will retrieve the correct instance.
    ''');
