@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import 'package:vyuh_core/plugin/network/http_network_plugin_web.dart';

void main() {
  test('createWebClient returns a browser client', () {
    final client = createWebClient();
    addTearDown(client.close);

    expect(client, isA<Client>());
    expect(client, isA<BrowserClient>());
  });

  test('createWebClient sends credentials with cross-origin requests', () {
    final client = createWebClient() as BrowserClient;
    addTearDown(client.close);

    expect(client.withCredentials, isTrue);
  });

  test('each call creates an independent client', () {
    final first = createWebClient();
    final second = createWebClient();
    addTearDown(first.close);
    addTearDown(second.close);

    expect(identical(first, second), isFalse);
  });

  test('a closed client rejects new requests', () async {
    final client = createWebClient()..close();

    await expectLater(
      client.get(Uri.parse('http://localhost/never-sent')),
      throwsA(isA<ClientException>()),
    );
  });
}
