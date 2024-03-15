import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sanity_client/sanity_client.dart';

const project = 'test-project';
const dataset = 'test-dataset';

SanityClient _getClient({final http.Client? httpClient}) => SanityClient(
      SanityConfig(
        projectId: project,
        dataset: dataset,
        token: 'test-token',
      ),
      httpClient: httpClient,
    );

const _sanityResponse = '''
{
  "ms": 0,
  "query": "",
  "result": {
  }
}
''';

void main() {
  group('Query handling', () {
    test('Client is ready with default SanityConfig', () async {
      final client = _getClient();

      expect(client, isNotNull);
      expect(client.config.apiVersion, equals(SanityConfig.defaultApiVersion));
      expect(client.config.useCdn, isTrue);
      expect(client.urlBuilder, TypeMatcher<SanityUrlBuilder>());
    });

    test('Client is ready with default url-builder', () async {
      final client = _getClient();

      expect(client.urlBuilder, TypeMatcher<SanityUrlBuilder>());
    });

    test('Request is constructed properly', () async {
      final httpClient = MockClient((final req) async {
        expect(req.url.host, contains('$project.apicdn.sanity.io'));
        expect(
          req.url.path,
          contains('${SanityConfig.defaultApiVersion}/data/query/test-dataset'),
        );

        expect(req.headers['Authorization'], equals('Bearer test-token'));

        return http.Response(_sanityResponse, 200);
      });

      final c1 = _getClient(httpClient: httpClient);

      await c1.fetch(c1.queryUrl('some query'));
    });

    test('Params are being sent properly', () async {
      final httpClient = MockClient((final req) async {
        expect(
          req.url.query,
          contains('test=true'),
        );

        return http.Response(_sanityResponse, 200);
      });

      final c1 = _getClient(httpClient: httpClient);

      await c1.fetch(c1.queryUrl('some query', params: {'test': 'true'}));
    });

    test('Correct domain is used when CDN is false', () async {
      final httpClient = MockClient((final req) async {
        expect(req.url.host, contains('$project.api.sanity.io'));
        return http.Response(_sanityResponse, 200);
      });
      final c1 = SanityClient(
        SanityConfig(
          projectId: 'test-project',
          dataset: 'test-dataset',
          token: 'test-token',
          useCdn: false,
        ),
        httpClient: httpClient,
      );

      await c1.fetch(c1.queryUrl('some query'));
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

      final client = _getClient(httpClient: httpClient);

      pairs.forEach((key, value) {
        test('Throws for $key', () {
          expect(
            () async {
              await client.fetch(client.queryUrl(key));
            },
            throwsA(value.$2),
          );
        });
      });
    });

    test('Exceptions thrown have proper toString()', () async {
      var message = '';
      try {
        final client = _getClient();
        await client.fetch(client.queryUrl('Unauthorized 403'));
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
        "ms": 0,
        "query": "",
        "result": {}
      }
      ''',
          200,
        ),
      );

      final client = _getClient(httpClient: httpClient);

      final response = await client.fetch(client.queryUrl('valid query'));
      expect(response.result, equals({}));
    });
  });

  group('Datasets', () {
    test('Can fetch datasets', () async {
      final httpClient = MockClient(
        (final request) async => http.Response(
          '''
      [
          { "name": "test-1", "aclMode": "none" },
          { "name": "test-2", "aclMode": "none" }
      ]
      ''',
          200,
        ),
      );

      final client = _getClient(httpClient: httpClient);

      final response = await client.datasets();

      expect(
        response,
        equals([
          SanityDataset(name: 'test-1', aclMode: 'none'),
          SanityDataset(name: 'test-2', aclMode: 'none'),
        ]),
      );

      // Hashcodes also match
      expect(
        response.map((final x) => x.hashCode),
        equals([
          SanityDataset(name: 'test-1', aclMode: 'none').hashCode,
          SanityDataset(name: 'test-2', aclMode: 'none').hashCode,
        ]),
      );
    });

    test('Can deal with empty datasets', () async {
      final httpClient = MockClient(
        (final request) async => http.Response(
          '''
      []
      ''',
          200,
        ),
      );

      final client = _getClient(httpClient: httpClient);

      final response = await client.datasets();
      expect(response, equals([]));
    });
  });

  group('Url building', () {
    [
      'invalid-ref',
      'imgInvalid-invalid-400x300-jpg',
    ].forEach((ref) {
      test('Invalid image-reference ($ref) throws exception', () {
        expect(
          () {
            _getClient().imageUrl(ref);
          },
          throwsA(const TypeMatcher<InvalidReferenceException>()),
        );
      });
    });

    test('Valid image-reference generates proper image-url', () {
      final url = _getClient()
          .imageUrl('image-Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000-jpg')
          .toString();
      expect(url, contains('Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000.jpg'));
      expect(url, contains('cdn.sanity.io/images/$project/$dataset/'));
    });

    [
      'invalid-ref',
      'fileInvalid-invalid-jpg',
    ].forEach((ref) {
      test('Invalid file-reference ($ref) throws exception', () {
        expect(
          () {
            _getClient().fileUrl(ref);
          },
          throwsA(const TypeMatcher<AssertionError>()),
        );
      });
    });

    test('Valid file-reference generates proper file-url', () {
      final url = _getClient()
          .fileUrl(
            'file-a3dabbe0f73305c46baeedadcea3e4f7b944a968-json',
          )
          .toString();
      expect(url, contains('a3dabbe0f73305c46baeedadcea3e4f7b944a968.json'));
      expect(url, contains('cdn.sanity.io/files/$project/$dataset/'));
    });

    test('Parameters are included in query', () {
      final url = _getClient()
          .imageUrl(
            'image-Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000-jpg',
            devicePixelRatio: 1,
            format: 'auto',
            width: 100,
            height: 100,
            quality: 45,
          )
          .toString();
      expect(url, contains('w=100'));
      expect(url, contains('h=100'));
      expect(url, contains('dpr=1'));
      expect(url, contains('q=45'));
      expect(url, contains('fm=auto'));
    });
  });
}
