import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;

import '../runtime/helpers.dart';

final class _FailingProvider extends Mock implements vc.TelemetryProvider {}

void main() {
  setUpAll(() => registerFallbackValue(const FlutterErrorDetails(exception: 0)));

  late List<String> logs;
  late DebugPrintCallback originalDebugPrint;

  setUp(() {
    logs = [];
    originalDebugPrint = debugPrint;
    debugPrint = (message, {wrapWidth}) => logs.add(message ?? '');
  });
  tearDown(() => debugPrint = originalDebugPrint);

  test(
    'a provider that throws does not stop the others or the caller',
    () async {
      final broken = RecordingTelemetry()..throwOnReport = true;
      final healthy = RecordingTelemetry();
      final telemetry = vc.TelemetryPlugin(providers: [broken, healthy]);

      await telemetry.reportError(StateError('boom'));

      expect(healthy.errors, hasLength(1));
      expect(
        logs.single,
        contains('telemetry provider RecordingTelemetry failed'),
      );
    },
  );

  test('a provider whose report fails asynchronously is contained', () async {
    final failing = _FailingProvider();
    when(
      () => failing.reportMessage(
        any(),
        params: any(named: 'params'),
        level: any(named: 'level'),
      ),
    ).thenAnswer((_) => Future.error(StateError('network down')));
    when(
      () => failing.reportFlutterError(any(), fatal: any(named: 'fatal')),
    ).thenAnswer((_) => Future.error(StateError('network down')));
    final healthy = RecordingTelemetry();
    final telemetry = vc.TelemetryPlugin(providers: [failing, healthy]);

    await telemetry.reportMessage('hello');
    await telemetry.reportFlutterError(
      FlutterErrorDetails(exception: Exception('render')),
    );

    expect(healthy.messages, contains('hello'));
    expect(logs, hasLength(2));
  });
}
