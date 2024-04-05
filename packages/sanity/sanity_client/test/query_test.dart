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

  test('Asserts that a token is provided', () async {
    expect(
      () => SanityConfig(
        projectId: project,
        dataset: dataset,
        token: '',
      ),
      throwsA(isA<AssertionError>()),
    );
  });

  test('Asserts that the apiVersion has a valid format', () async {
    expect(
      () => SanityConfig(
        projectId: project,
        dataset: dataset,
        token: token,
        apiVersion: 'invalid',
      ),
      throwsA(isA<AssertionError>()),
    );
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
      expect(req.url.query, contains('test=true'));
      expect(req.url.query, contains('explain=true'));
      expect(req.url.toString(), contains('api.sanity.io'));
      expect(req.url.path, contains('v2024-02-16'));

      return http.Response(_sanityResponse, 200);
    });

    final c1 = getClient(
      httpClient: httpClient,
      explainQuery: true,
      perspective: Perspective.previewDrafts,
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

  test('Parses results for valid query', () async {
    final httpClient = MockClient(
      (final request) async => http.Response(
        '''
      {
        "ms": 20,
        "query": "",
        "result": {}
      }
      ''',
        200,
      ),
    );

    final client = getClient(httpClient: httpClient);

    final response = await client.fetch('valid query');
    expect(response.result, equals({}));
    expect(response.info.serverTimeMs, equals(20));
  });
}
