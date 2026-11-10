import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;

/// A route that shows `page <path>`.
GoRoute page(String path, {String? name}) =>
    GoRoute(path: path, name: name, builder: (_, _) => Text('page $path'));

/// A feature with the given routes.
vc.FeatureDescriptor feature(
  String name, {
  List<RouteBase>? routes,
  List<String> dependencies = const [],
  vc.VoidFutureFunction? init,
  vc.VoidFutureFunction? dispose,
  List<vc.ExtensionDescriptor>? extensions,
  List<vc.ExtensionBuilder>? extensionBuilders,
  List<vc.FeatureRedirect> redirects = const [],
}) => vc.FeatureDescriptor(
  name: name,
  title: name,
  dependencies: dependencies,
  init: init,
  dispose: dispose,
  extensions: extensions,
  extensionBuilders: extensionBuilders,
  redirects: redirects,
  routes: () => routes ?? [page('/$name')],
);

/// The home feature at `/`.
vc.FeatureDescriptor home() => feature('home', routes: [page('/')]);

/// Disposes the running platform, if any.
Future<void> disposePlatform() async {
  if (vc.VyuhBinding.instance.initialized) await vc.vyuh.dispose();
}

/// A telemetry provider that records what it is given.
final class RecordingTelemetry implements vc.TelemetryProvider {
  final errors = <Object?>[];
  final messages = <String>[];

  /// When true, [reportError] throws synchronously.
  bool throwOnReport = false;

  @override
  String get name => 'test.telemetry';

  @override
  String get title => 'Recording Telemetry';

  @override
  String get description => 'Records errors and messages';

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> reportError(
    dynamic exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? params,
    bool fatal = false,
  }) {
    if (throwOnReport) throw StateError('telemetry is down');
    errors.add(exception);
    return Future.value();
  }

  @override
  Future<void> reportFlutterError(
    FlutterErrorDetails details, {
    bool fatal = false,
  }) async {}

  @override
  Future<void> reportMessage(
    String message, {
    Map<String, dynamic>? params,
    vc.LogLevel? level = vc.LogLevel.info,
  }) async {
    messages.add(message);
  }

  @override
  Future<vc.Trace> startTrace(
    String name,
    String operation, {
    vc.LogLevel? level = vc.LogLevel.info,
  }) async => vc.NoOpTrace();
}

/// Plugins that report to [telemetry].
vc.PluginDescriptor recordingPlugins(
  RecordingTelemetry telemetry, {
  vc.NavigationPlugin? navigation,
  vc.EventPlugin? event,
  List<vc.Plugin>? others,
}) => vc.PluginDescriptor(
  telemetry: vc.TelemetryPlugin(providers: [telemetry]),
  navigation: navigation ?? vc.DefaultNavigationPlugin(),
  event: event ?? vc.DefaultEventPlugin(),
  others: others,
);

final class TestDescriptor extends vc.ExtensionDescriptor {
  TestDescriptor() : super(title: 'Test Descriptor');

  @override
  void onSourceFeatureUpdated() {}
}

/// An extension builder for [TestDescriptor].
class TestBuilder extends vc.ExtensionBuilder<TestDescriptor> {
  final List<TestDescriptor> registered = [];

  TestBuilder({super.title = 'Test Builder'})
    : super(extensionType: TestDescriptor);

  @override
  Future<void> onInit(List<TestDescriptor> extensions) async {
    registered.addAll(extensions);
  }

  @override
  Future<void> onDispose() async {
    registered.clear();
  }
}
