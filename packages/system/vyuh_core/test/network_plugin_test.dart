import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vyuh_core/vyuh_core.dart';

class MockClient extends Mock implements Client {}

void main() {
  group('NetworkPlugin', () {
    late MockClient mockClient;

    setUp(() async {
      mockClient = MockClient();
      registerFallbackValue(Uri.parse('https://example.com'));

      runApp(
        features: () => [],
        plugins: PluginDescriptor(
          network: HttpNetworkPlugin(client: mockClient),
        ),
      );

      await pumpEventQueue();
    });

    test('initializes correctly', () {
      expect(vyuh.network, isNotNull);
    });

    test('makes GET request', () async {
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => Response('{"result": "success"}', 200));

      final response = await vyuh.network.get(Uri.parse('https://example.com'));
      expect(response.statusCode, equals(200));
      expect(response.body, equals('{"result": "success"}'));

      verify(() => mockClient.get(any())).called(1);
    });

    test('makes POST request', () async {
      when(() => mockClient.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => Response('{"result": "success"}', 200));

      final response = await vyuh.network.post(
        Uri.parse('https://example.com'),
        body: {'test': 'data'},
      );
      expect(response.statusCode, equals(200));
      expect(response.body, equals('{"result": "success"}'));

      verify(() => mockClient.post(any(), body: {'test': 'data'})).called(1);
    });

    test('makes PUT request', () async {
      when(() => mockClient.put(any(), body: any(named: 'body')))
          .thenAnswer((_) async => Response('{"result": "success"}', 200));

      final response = await vyuh.network.put(
        Uri.parse('https://example.com'),
        body: {'test': 'data'},
      );
      expect(response.statusCode, equals(200));
      expect(response.body, equals('{"result": "success"}'));

      verify(() => mockClient.put(any(), body: {'test': 'data'})).called(1);
    });

    test('makes DELETE request', () async {
      when(() => mockClient.delete(any()))
          .thenAnswer((_) async => Response('{"result": "success"}', 200));

      final response = await vyuh.network.delete(
        Uri.parse('https://example.com'),
      );
      expect(response.statusCode, equals(200));
      expect(response.body, equals('{"result": "success"}'));

      verify(() => mockClient.delete(any())).called(1);
    });

    test('makes HEAD request', () async {
      when(() => mockClient.head(any()))
          .thenAnswer((_) async => Response('', 200));

      final response =
          await vyuh.network.head(Uri.parse('https://example.com'));
      expect(response.statusCode, equals(200));

      verify(() => mockClient.head(any())).called(1);
    });

    test('makes PATCH request', () async {
      when(() => mockClient.patch(any(), body: any(named: 'body')))
          .thenAnswer((_) async => Response('{"result": "success"}', 200));

      final response = await vyuh.network.patch(
        Uri.parse('https://example.com'),
        body: {'test': 'data'},
      );
      expect(response.statusCode, equals(200));
      expect(response.body, equals('{"result": "success"}'));

      verify(() => mockClient.patch(any(), body: {'test': 'data'})).called(1);
    });

    test('reads string content', () async {
      when(() => mockClient.read(any()))
          .thenAnswer((_) async => '{"result": "success"}');

      final content = await vyuh.network.read(Uri.parse('https://example.com'));
      expect(content, equals('{"result": "success"}'));

      verify(() => mockClient.read(any())).called(1);
    });

    test('reads bytes content', () async {
      final bytes = Uint8List.fromList([1, 2, 3, 4]);
      when(() => mockClient.readBytes(any())).thenAnswer((_) async => bytes);

      final content =
          await vyuh.network.readBytes(Uri.parse('https://example.com'));
      expect(content, equals(bytes));

      verify(() => mockClient.readBytes(any())).called(1);
    });

    test('handles request failure', () async {
      when(() => mockClient.get(any())).thenThrow(ArgumentError('Invalid URL'));

      expect(
        () => vyuh.network.get(Uri.parse('invalid-url')),
        throwsA(isA<ArgumentError>()),
      );

      verify(() => mockClient.get(any())).called(1);
    });

    test('retries failed requests', () async {
      var attempts = 0;
      when(() => mockClient.get(any())).thenAnswer((_) async {
        attempts++;
        if (attempts < 3) {
          throw TimeoutException('Request timed out');
        }
        return Response('{"result": "success"}', 200);
      });

      final response = await vyuh.network.get(Uri.parse('https://example.com'));
      expect(response.statusCode, equals(200));
      expect(attempts, equals(3));

      verify(() => mockClient.get(any())).called(3);
    });

    test('handles socket exceptions with retry', () async {
      var attempts = 0;
      when(() => mockClient.get(any())).thenAnswer((_) async {
        attempts++;
        if (attempts < 3) {
          throw const SocketException('Failed to connect');
        }
        return Response('{"result": "success"}', 200);
      });

      final response = await vyuh.network.get(Uri.parse('https://example.com'));
      expect(response.statusCode, equals(200));
      expect(attempts, equals(3));

      verify(() => mockClient.get(any())).called(3);
    });

    test('respects custom timeout', () async {
      runApp(
        features: () => [],
        plugins: PluginDescriptor(
          network: HttpNetworkPlugin(
            client: mockClient,
            timeout: Duration(milliseconds: 100),
          ),
        ),
      );
      await pumpEventQueue();

      when(() => mockClient.get(any())).thenAnswer(
        (_) async {
          await Future.delayed(Duration(milliseconds: 200));
          return Response('', 200);
        },
      );

      expect(
        () => vyuh.network.get(Uri.parse('https://example.com')),
        throwsA(isA<TimeoutException>()),
      );
    });

    test('disposes client properly', () async {
      await vyuh.network.dispose();
      verify(() => mockClient.close()).called(1);
    });
  });
}
