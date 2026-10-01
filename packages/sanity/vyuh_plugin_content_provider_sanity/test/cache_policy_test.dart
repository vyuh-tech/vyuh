import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sanity_client/sanity_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_plugin_content_provider_sanity/vyuh_plugin_content_provider_sanity.dart';

class _TestExtensions extends ExtensionBuilder<ExtensionDescriptor> {
  _TestExtensions() : super(title: 'Test', extensionType: ExtensionDescriptor);
}

class _TestRoute implements RouteBase {
  _TestRoute(this.revision);
  final int revision;

  @override
  String get path => '/test';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestContentPlugin extends ContentPlugin {
  _TestContentPlugin()
      : super(provider: NoOpContentProvider(), name: 'test', title: 'Test');

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  @override
  void attach(ExtensionBuilder extBuilder) {}

  @override
  T? fromJson<T>(Map<String, dynamic> json) =>
      _TestRoute(json['revision'] as int) as T;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SanityContentProvider provider;
  late int requests;

  setUp(() async {
    VyuhBinding.instance.widgetInit(
        plugins: PluginDescriptor(content: _TestContentPlugin()),
        extensionBuilder: _TestExtensions(),
        extensionDescriptors: []);
    await VyuhBinding.instance.widgetReady;
    requests = 0;
    provider = SanityContentProvider(SanityClient(
      SanityConfig(
          projectId: 'test', dataset: 'production', apiVersion: 'v2025-02-19'),
      httpClient: MockClient((request) async {
        requests++;
        return http.Response(
            jsonEncode({
              'ms': 1,
              'query': request.url.queryParameters['query'],
              'result': {'_id': 'doc', '_type': 'test', 'revision': requests},
            }),
            200);
      }),
    ));
  });

  tearDown(() async {
    await provider.dispose();
    await VyuhBinding.instance.dispose();
  });

  test('fetchById honors cache bypass', () async {
    await provider.fetchById('doc', fromJson: identity);
    await provider.fetchById('doc', fromJson: identity);
    expect(requests, 1);
    final fresh =
        await provider.fetchById('doc', fromJson: identity, useCache: false);
    expect(requests, 2);
    expect(fresh?['revision'], 2);
  });

  test('fetchRoute honors cache bypass', () async {
    final first = await provider.fetchRoute(path: '/test') as _TestRoute;
    final cached = await provider.fetchRoute(path: '/test') as _TestRoute;
    expect(first.path, '/test');
    expect(cached.revision, first.revision);
    expect(requests, 1);
    final fresh =
        await provider.fetchRoute(path: '/test', useCache: false) as _TestRoute;
    expect(requests, 2);
    expect(fresh.revision, 2);
  });

  test('dispose clears previously cached responses', () async {
    await provider.fetchById('doc', fromJson: identity);
    await provider.dispose();
    await provider.fetchById('doc', fromJson: identity);
    expect(requests, 2);
  });
}
