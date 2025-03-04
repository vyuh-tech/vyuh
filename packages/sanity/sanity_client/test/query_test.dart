import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sanity_client/sanity_client.dart';

import 'util.dart';

const _sanityResponse = '''
{
  "ms": 0,
  "query": "",
  "result": {
  }
}
''';

void main() {
  test('Client is ready with default SanityConfig', () async {
    final client = getClient();

    expect(client, isNotNull);
    expect(client.config.apiVersion, equals(SanityConfig.defaultApiVersion));
    expect(client.config.useCdn, isTrue);
    expect(client.urlBuilder, isA<SanityUrlBuilder>());
  });

  test('Client is ready with default url-builder', () async {
    final client = getClient();

    expect(client.urlBuilder, isA<SanityUrlBuilder>());
  });

  test('Request is constructed properly', () async {
    final httpClient = MockClient((final req) async {
      expect(req.url.host, contains('$project.apicdn.sanity.io'));
      expect(
        req.url.path,
        contains('${SanityConfig.defaultApiVersion}/data/query/$dataset'),
      );

      expect(req.headers['Authorization'], equals('Bearer $token'));

      return http.Response(_sanityResponse, 200);
    });

    final c1 = getClient(httpClient: httpClient);

    await c1.fetch('some query');
  });

  test('Params are being sent properly', () async {
    final httpClient = MockClient((final req) async {
      expect(
          req.url.query,
          contains(
              '${Uri.encodeComponent('\$test')}=${Uri.encodeComponent('"true"')}'));
      expect(req.url.query, contains('explain=true'));
      expect(req.url.toString(), contains('api.sanity.io'));
      expect(req.url.path, contains('v2024-02-16'));

      return http.Response(_sanityResponse, 200);
    });

    final c1 = getClient(
      httpClient: httpClient,
      explainQuery: true,
      perspective: Perspective.drafts,
      useCdn: false,
      apiVersion: 'v2024-02-16',
    );

    await c1.fetch('some query', params: {'test': 'true'});
  });

  test('Correct domain is used when CDN is false', () async {
    final httpClient = MockClient((final req) async {
      expect(req.url.host, contains('$project.api.sanity.io'));
      return http.Response(_sanityResponse, 200);
    });
    final c1 = SanityClient(
      SanityConfig(
        projectId: project,
        dataset: dataset,
        token: token,
        useCdn: false,
        perspective: Perspective.drafts,
      ),
      httpClient: httpClient,
    );

    await c1.fetch('some query');
  });

  group('Throws an exception for invalid conditions', () {
    final Map<String, (http.Response, TypeMatcher)> pairs = {
      'Bad query': (
        http.Response('', 400),
        const TypeMatcher<BadRequestException>()
      ),
      'Network 404': (
        http.Response('', 404),
        const TypeMatcher<FetchDataException>()
      ),
      'Bad query 500': (
        http.Response('', 500),
        const TypeMatcher<FetchDataException>()
      ),
      'Unauthorized 401': (
        http.Response('', 401),
        const TypeMatcher<UnauthorizedException>()
      ),
      'Unauthorized 403': (
        http.Response('', 403),
        const TypeMatcher<UnauthorizedException>()
      ),
    };

    final httpClient = MockClient((final req) async {
      final query = req.url.queryParameters['query'];
      return pairs[query]?.$1 ?? http.Response('', 200);
    });

    final client = getClient(httpClient: httpClient);

    pairs.forEach((key, value) {
      test('Throws for $key', () {
        expect(
          () async {
            await client.fetch(key);
          },
          throwsA(value.$2),
        );
      });
    });
  });

  test('Exceptions thrown have proper toString()', () async {
    var message = '';
    try {
      final client = getClient();
      await client.fetch('Unauthorized 403');
    } catch (e) {
      message = e.toString();
    }
    expect(
      message,
      startsWith('Unauthorized: {'),
    );
  });

  test('Parses results for valid query, with results as a Map', () async {
    final httpClient = MockClient(
      (final request) async => http.Response(
        '''
      {
        "ms": 20,
        "query": "",
        "result": {"_type": "someType"}
      }
      ''',
        200,
      ),
    );

    final client = getClient(httpClient: httpClient);

    final response = await client.fetch('valid query');
    expect(response.result, equals({'_type': 'someType'}));
    expect(response.info.serverTimeMs, equals(20));
  });

  test('Parses results for valid query, with results as a List', () async {
    final httpClient = MockClient(
      (final request) async => http.Response(
        '''
      {
        "ms": 20,
        "query": "",
        "result": [{"_type": "someType"}]
      }
      ''',
        200,
      ),
    );

    final client = getClient(httpClient: httpClient);

    final response = await client.fetch('valid query');
    expect(
        response.result,
        equals([
          {'_type': 'someType'}
        ]));
    expect(response.info.serverTimeMs, equals(20));
  });

  group('Request method selection based on query size', () {
    late MockClient httpClient;
    late SanityClient client;

    setUp(() {
      httpClient = MockClient((req) async {
        return http.Response(_sanityResponse, 200);
      });
      client = getClient(httpClient: httpClient);
    });

    test('Uses GET for queries under 11kB', () async {
      // Small query should use GET
      final smallQuery = 'some small query';

      httpClient = MockClient((req) async {
        expect(req.method, equals('GET'));
        return http.Response(_sanityResponse, 200);
      });
      client.setHttpClient(httpClient);

      await client.fetch(smallQuery);
    });

    test('Uses POST for queries over 11kB', () async {
      // Create a query that's definitely over 11kB
      final largeQuery = 'x' * (11 * 1024 + 100); // 11kB + 100 bytes

      httpClient = MockClient((req) async {
        expect(req.method, equals('POST'));
        expect(req.headers['Content-Type'],
            equals('application/json; charset=UTF-8'));
        return http.Response(_sanityResponse, 200);
      });
      client.setHttpClient(httpClient);

      await client.fetch(largeQuery);
    });

    test('Handles edge case near 11kB limit', () async {
      // Create a query that's exactly 11kB
      final edgeQuery = 'x' * (11 * 1014);

      httpClient = MockClient((req) async {
        expect(req.method, equals('GET'));
        return http.Response(_sanityResponse, 200);
      });
      client.setHttpClient(httpClient);

      await client.fetch(edgeQuery);

      // Now try with one byte over
      final overQuery = 'x' * (11 * 1024 + 1);

      httpClient = MockClient((req) async {
        expect(req.method, equals('POST'));
        return http.Response(_sanityResponse, 200);
      });
      client.setHttpClient(httpClient);

      await client.fetch(overQuery);
    });

    test('POST request properly formats params without \$ prefix', () async {
      final largeQuery = 'x' * (11 * 1024 + 100);
      final params = {'\$testParam': 'value'};

      httpClient = MockClient((req) async {
        expect(req.method, equals('POST'));

        final body = jsonDecode(req.body) as Map<String, dynamic>;
        expect(
          body['params'],
          containsPair('testParam', 'value'),
        );
        expect(body['query'], equals(largeQuery));

        return http.Response(_sanityResponse, 200);
      });
      client.setHttpClient(httpClient);

      await client.fetch(largeQuery, params: params);
    });
  });

  group('Authentication Tests', () {
    test('includes token in request headers', () async {
      final client = getClient(
        httpClient: MockClient((request) async {
          expect(
            request.headers['Authorization'],
            equals('Bearer $token'),
          );
          return http.Response('{"ms":0,"query":"","result":{}}', 200);
        }),
      );
      await client.fetch('*');
    });

    test('handles unauthorized requests', () async {
      final client = getClient(
        httpClient: MockClient((request) async {
          return http.Response(
            '{"error":{"description":"Unauthorized"}}',
            401,
          );
        }),
      );

      expect(
        () => client.fetch('*'),
        throwsA(isA<UnauthorizedException>()),
      );
    });
  });
}
