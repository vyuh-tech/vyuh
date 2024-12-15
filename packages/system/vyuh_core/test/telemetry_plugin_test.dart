import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart';

class MockTelemetryProvider implements TelemetryProvider {
  final List<String> messages = [];
  final List<dynamic> errors = [];
  final List<FlutterErrorDetails> flutterErrors = [];
  final List<Trace> traces = [];

  @override
  String get name => 'mock_telemetry';

  @override
  String get title => 'Mock Telemetry';

  @override
  String get description => 'A mock telemetry provider for testing';

  @override
  List<NavigatorObserver> get observers => [];

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> reportMessage(String message,
      {Map<String, dynamic>? params, LogLevel? level = LogLevel.info}) async {
    messages.add(message);
  }

  @override
  Future<void> reportError(dynamic exception,
      {StackTrace? stackTrace,
      Map<String, dynamic>? params,
      bool fatal = false}) async {
    errors.add(exception);
  }

  @override
  Future<void> reportFlutterError(FlutterErrorDetails details,
      {bool fatal = false}) async {
    flutterErrors.add(details);
  }

  @override
  Future<Trace> startTrace(String name, String operation,
      {LogLevel? level = LogLevel.info}) async {
    final trace = NoOpTrace();
    traces.add(trace);
    return trace;
  }
}

void main() {
  group('TelemetryPlugin', () {
    late TelemetryPlugin telemetryPlugin;
    late MockTelemetryProvider mockProvider;

    setUp(() {
      mockProvider = MockTelemetryProvider();
      telemetryPlugin = TelemetryPlugin(providers: [mockProvider]);
    });

    test('initializes all providers', () async {
      await telemetryPlugin.initOnce();
      expect(mockProvider.traces.isEmpty, isTrue);
    });

    test('reports messages to all providers', () async {
      const testMessage = 'Test message';
      await telemetryPlugin.reportMessage(testMessage);
      expect(mockProvider.messages, contains(testMessage));
    });

    test('reports errors to all providers', () async {
      final testError = Exception('Test error');
      await telemetryPlugin.reportError(testError);
      expect(mockProvider.errors, contains(testError));
    });

    test('reports flutter errors to all providers', () async {
      final details = FlutterErrorDetails(
        exception: Exception('Flutter error'),
        library: 'test',
        context: ErrorDescription('Test context'),
      );
      await telemetryPlugin.reportFlutterError(details);
      expect(mockProvider.flutterErrors, contains(details));
    });

    test('starts traces through all providers', () async {
      final trace = await telemetryPlugin.startTrace('test', 'operation');
      expect(trace, isNotNull);
      expect(mockProvider.traces.length, equals(1));
    });

    test('disposes all providers', () async {
      await telemetryPlugin.disposeOnce();
      // Since MockTelemetryProvider's dispose is empty, we just verify it doesn't throw
      expect(true, isTrue);
    });
  });
}
