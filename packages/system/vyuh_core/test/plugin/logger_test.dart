import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_test/vyuh_test.dart';

/// Records every message that reaches telemetry, with its level.
final class RecordingTelemetry implements vc.TelemetryProvider {
  final messages = <(vc.LogLevel?, String)>[];

  @override
  String get name => 'recording';

  @override
  String get title => 'Recording';

  @override
  String get description => 'Recording';

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> reportError(
    exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? params,
    bool fatal = false,
  }) async {}

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
  }) async => messages.add((level, message));

  @override
  Future<vc.Trace> startTrace(
    String name,
    String operation, {
    vc.LogLevel? level = vc.LogLevel.info,
  }) async => vc.NoOpTrace();
}

vc.FeatureDescriptor homeFeature() => vc.FeatureDescriptor(
  name: 'home',
  title: 'Home',
  routes: () => [GoRoute(path: '/', builder: (_, _) => const Text('home'))],
);

void main() {
  tearDown(() async {
    if (vc.VyuhBinding.instance.initialized) await vc.vyuh.dispose();
  });

  testWidgets('each log call reports its message at the matching level', (
    tester,
  ) async {
    final telemetry = RecordingTelemetry();
    vc.runApp(
      features: () => [homeFeature()],
      plugins: vc.PluginDescriptor(
        telemetry: vc.TelemetryPlugin(providers: [telemetry]),
      ),
    );
    await vc.vyuh.getReady(tester);
    telemetry.messages.clear();

    final log = vc.VyuhBinding.instance.log;
    log.trace('t');
    log.debug('d');
    log.info('i');
    log.warn('w');
    log.error('e', error: StateError('x'));
    log.fatal('f', error: StateError('y'), stackTrace: StackTrace.current);

    expect(telemetry.messages, [
      (vc.LogLevel.trace, 't'),
      (vc.LogLevel.debug, 'd'),
      (vc.LogLevel.info, 'i'),
      (vc.LogLevel.warning, 'w'),
      (vc.LogLevel.error, 'e'),
      (vc.LogLevel.fatal, 'f'),
    ]);
  });

  testWidgets('vyuh.log is the binding logger', (tester) async {
    vc.runApp(features: () => [homeFeature()]);
    await vc.vyuh.getReady(tester);

    expect(vc.vyuh.log, same(vc.VyuhBinding.instance.log));
  });
}
