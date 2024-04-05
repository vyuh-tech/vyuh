import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sanity_client/sanity_client.dart';

import 'util.dart';

void main() {
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

    final client = getClient(httpClient: httpClient);

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

    final client = getClient(httpClient: httpClient);

    final response = await client.datasets();
    expect(response, equals([]));
  });
}
