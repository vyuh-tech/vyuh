import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sanity_client/sanity_client.dart';

void main() {
  for (final method in ['GET', 'POST']) {
    test('$method measures transport rather than server timing header',
        () async {
      final client = SanityClient(
        SanityConfig(projectId: 'test', dataset: 'production'),
        httpClient: MockClient((request) async {
          expect(request.method, method);
          await Future<void>.delayed(const Duration(milliseconds: 30));
          return http.Response(
            jsonEncode({'ms': 4, 'query': 'test', 'result': null}),
            200,
            headers: {
              'server-timing': 'api;dur=987654.5, edge;dur=1.2',
              'x-sanity-age': '12',
              'x-sanity-shard': 'test-shard',
            },
          );
        }),
      );

      final response =
          await client.fetch(method == 'GET' ? 'test' : 'x' * 12000);
      expect(response.info.clientTimeMs, greaterThanOrEqualTo(20));
      expect(response.info.clientTimeMs, lessThan(987654));
      expect(response.info.serverTimeMs, 4);
      expect(response.info.age, 12);
      expect(response.info.shard, 'test-shard');
    });
  }
}
