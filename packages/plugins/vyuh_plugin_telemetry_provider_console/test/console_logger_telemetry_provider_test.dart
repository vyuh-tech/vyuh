import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:vyuh_core/vyuh_core.dart' hide Logger;
import 'package:vyuh_plugin_telemetry_provider_console/vyuh_plugin_telemetry_provider_console.dart';

void main() {
  late ConsoleLoggerTelemetryProvider provider;
  late List<LogEvent> events;

  void recordEvent(LogEvent event) => events.add(event);

  /// Runs [body] and returns everything it printed to the console.
  Future<String> capturePrint(Future<void> Function() body) async {
    final lines = <String>[];
    await runZoned(
      body,
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) => lines.add(line),
      ),
    );
    return lines.join('\n');
  }

  setUp(() async {
    events = [];
    Logger.addLogListener(recordEvent);
    provider = ConsoleLoggerTelemetryProvider();
    await provider.init();
  });

  tearDown(() async {
    Logger.removeLogListener(recordEvent);
    await provider.dispose();
  });

  test('describes itself as a telemetry provider', () {
    expect(provider, isA<TelemetryProvider>());
    expect(provider.name, 'vyuh.plugin.telemetry.provider.console');
    expect(provider.title, 'Console Logger Telemetry Provider');
    expect(provider.description, 'A simple Console-logger Telemetry Provider');
  });

  group('reportMessage', () {
    test('prints the message to the console', () async {
      final output = await capturePrint(
        () => provider.reportMessage('hello from vyuh'),
      );

      expect(output, contains('hello from vyuh'));
    });

    test('defaults to the info level', () async {
      await capturePrint(() => provider.reportMessage('default level'));

      expect(events.single.level, Level.info);
      expect(events.single.message, 'default level');
    });

    test('maps each LogLevel to the matching logger level', () async {
      const expected = {
        LogLevel.fatal: Level.fatal,
        LogLevel.error: Level.error,
        LogLevel.warning: Level.warning,
        LogLevel.info: Level.info,
        LogLevel.debug: Level.debug,
        LogLevel.trace: Level.trace,
      };

      for (final MapEntry(key: level, value: loggerLevel) in expected.entries) {
        events.clear();
        final output = await capturePrint(
          () => provider.reportMessage('at ${level.name}', level: level),
        );

        expect(events.single.level, loggerLevel, reason: '$level');
        expect(output, contains('at ${level.name}'), reason: '$level');
      }
    });

    test('logs a null level at info', () async {
      await capturePrint(
        () => provider.reportMessage('no level', level: null),
      );

      expect(events.single.level, Level.info);
    });

    test('accepts params without printing them', () async {
      final output = await capturePrint(
        () => provider.reportMessage('with params', params: {'id': 'p1'}),
      );

      expect(output, contains('with params'));
      expect(output, isNot(contains('p1')));
    });
  });

  group('reportError', () {
    test('prints the error and its stack trace', () async {
      final stack = StackTrace.fromString('#0      failingFunction (x.dart:1)');

      final output = await capturePrint(
        () => provider.reportError(
          StateError('boom'),
          stackTrace: stack,
          params: {'id': 'e1'},
          fatal: true,
        ),
      );

      expect(output, contains('Error observed'));
      expect(output, contains('Bad state: boom'));
      expect(output, contains('failingFunction'));

      final event = events.single;
      expect(event.level, Level.error);
      expect(event.error, isA<StateError>());
      expect(event.stackTrace, same(stack));
    });

    test('works without a stack trace', () async {
      final output = await capturePrint(
        () => provider.reportError('plain failure'),
      );

      expect(output, contains('Error observed'));
      expect(output, contains('plain failure'));
      expect(events.single.stackTrace, isNull);
    });
  });

  group('reportFlutterError', () {
    test('prints the library, summary, exception and stack', () async {
      final stack = StackTrace.fromString('#0      buildWidget (w.dart:7)');
      final details = FlutterErrorDetails(
        exception: Exception('render failed'),
        stack: stack,
        library: 'widgets library',
      );

      final output = await capturePrint(
        () => provider.reportFlutterError(details, fatal: true),
      );

      expect(output, contains('Flutter Error observed in widgets library'));
      expect(output, contains('-----'));
      expect(output, contains('${details.summary}'));
      expect(output, contains('Exception: render failed'));
      expect(output, contains('buildWidget'));

      final event = events.single;
      expect(event.level, Level.error);
      expect(event.error, same(details.exception));
      expect(event.stackTrace, same(stack));
    });
  });

  group('startTrace', () {
    test('returns a no-op trace that records nothing', () async {
      late Trace trace;
      final output = await capturePrint(() async {
        trace = await provider.startTrace(
          'load',
          'network',
          level: LogLevel.debug,
        );
      });

      expect(trace, isA<NoOpTrace>());
      expect(output, isEmpty);
      expect(events, isEmpty);

      trace.setMetric('count', 3);
      trace.setAttributes({'key': 'value'});
      expect(trace.getMetric('count'), 0);
      expect(trace.getAttributes(), isEmpty);

      final child = await trace.startChild('child', 'op');
      expect(child, isA<NoOpTrace>());
      await child.stop();
      await trace.stop();
    });
  });

  group('lifecycle', () {
    test('init replaces an open logger and keeps logging', () async {
      await provider.init();

      final output = await capturePrint(
        () => provider.reportMessage('after re-init'),
      );

      expect(output, contains('after re-init'));
    });

    test('logging after dispose fails until init is called again', () async {
      await provider.dispose();

      await expectLater(
        provider.reportMessage('while closed'),
        throwsArgumentError,
      );

      await provider.init();
      final output = await capturePrint(
        () => provider.reportMessage('after restart'),
      );

      expect(output, contains('after restart'));
    });

    test('a fresh provider logs without an explicit init', () async {
      final fresh = ConsoleLoggerTelemetryProvider();

      final output = await capturePrint(
        () => fresh.reportMessage('no init needed'),
      );

      expect(output, contains('no init needed'));
      await fresh.dispose();
    });
  });
}
