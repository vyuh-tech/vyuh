import 'dart:async';
import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sanity_client/sanity_client.dart';

import 'util.dart';

http.Response response(String value) => http.Response(
  jsonEncode({
    'result': value,
    'ms': 1,
    'query': '*',
    'syncTags': ['tag'],
  }),
  200,
);

void main() {
  late List<Completer<http.Response>> requests;
  late List<Uri> queries;
  late LiveHttp server;

  /// Queries wait in [requests] for the test to answer them.
  LiveHttp held() => server = LiveHttp(
    onQuery: (request) {
      queries.add(request.url);
      final response = Completer<http.Response>();
      requests.add(response);
      return response.future;
    },
  );

  /// Queries are answered at once.
  LiveHttp answering() => server = LiveHttp(
    onQuery: (request) async {
      queries.add(request.url);
      return response('value');
    },
  );

  setUp(() {
    requests = [];
    queries = [];
  });

  test(
    'connects to the live events endpoint with the client headers',
    () async {
      final client = getClient(httpClient: answering());
      final subscription = client.fetchLive('*').listen((_) {});
      final request = server.live.single.request;
      expect(request.method, 'GET');
      expect(request.url.path, '/vX/data/live/events/$dataset');
      expect(request.headers['Accept'], 'text/event-stream');
      expect(request.headers['Authorization'], 'Bearer $token');
      await subscription.cancel();
    },
  );

  test('a welcome event runs the query with its event id', () async {
    final client = getClient(httpClient: answering());
    final values = <dynamic>[];
    final subscription = client
        .fetchLive('*')
        .listen((response) => values.add(response.result));
    final events = server.live.single.open();
    events.add(utf8.encode('event: welcome\nid: abc\n\n'));
    await flush();
    await flush();
    expect(values, ['value']);
    expect(queries.single.queryParameters['\$lastLiveEventId'], '"abc"');
    await subscription.cancel();
  });

  test(
    'a message runs the query only when it carries one of its tags',
    () async {
      final client = getClient(httpClient: answering());
      final values = <dynamic>[];
      final subscription = client
          .fetchLive('*')
          .listen((response) => values.add(response.result));
      final events = server.live.single.open();
      events.add(utf8.encode('event: welcome\nid: 1\n\n'));
      await flush();
      await flush();
      events.add(utf8.encode(': keep-alive\n\n'));
      events.add(utf8.encode('id: 2\ndata: {"tags":["other"]}\n\n'));
      await flush();
      await flush();
      expect(values, hasLength(1));
      events.add(
        utf8.encode('id: 3\ndata: {\ndata: "tags":["tag"]\ndata: }\n\n'),
      );
      await flush();
      await flush();
      expect(values, hasLength(2));
      await subscription.cancel();
    },
  );

  test('bursts coalesce and suppress an obsolete result', () async {
    final client = getClient(httpClient: held());
    final values = <dynamic>[];
    final subscription = client
        .fetchLive('*')
        .listen((response) => values.add(response.result));
    final events = server.live.single.open();
    events.add(utf8.encode('event: welcome\nid: 1\n\n'));
    await flush();
    events.add(
      utf8.encode('event: restart\nid: 2\n\nevent: restart\nid: 3\n\n'),
    );
    await flush();
    expect(requests, hasLength(1));
    requests.first.complete(response('old'));
    await flush();
    expect(requests, hasLength(2));
    expect(values, isEmpty);
    requests.last.complete(response('new'));
    await flush();
    expect(values, ['new']);
    await subscription.cancel();
    expect(server.live.single.bodyCancelled, isTrue);
    expect(events.hasListener, isFalse);
  });

  test(
    'connection, server and malformed event errors reach the subscriber',
    () {
      fakeAsync((async) {
        final errors = <Object>[];
        final client = getClient(httpClient: answering());
        final subscription = client
            .fetchLive('*')
            .listen((_) {}, onError: errors.add);
        server.live.single.fail(http.ClientException('offline'));
        async.flushMicrotasks();
        expect(errors.single, isA<LiveConnectException>());
        expect(errors.single.toString(), contains('offline'));
        errors.clear();

        async.elapse(const Duration(seconds: 3));
        final events = server.live.last.open();
        async.flushMicrotasks();
        events.add(utf8.encode('event: error\ndata: {}\n\n'));
        async.flushMicrotasks();
        expect(errors.single, isA<LiveConnectException>());
        errors.clear();

        events.add(utf8.encode('id: 1\ndata: {bad\n\n'));
        async.flushMicrotasks();
        expect(errors.single, isA<FormatException>());
        unawaited(subscription.cancel());
        async.flushMicrotasks();
      });
    },
  );

  test('a refused connection reaches the subscriber', () async {
    final errors = <Object>[];
    final client = getClient(httpClient: answering());
    final subscription = client
        .fetchLive('*')
        .listen((_) {}, onError: errors.add);
    server.live.single.open(status: 401, body: 'no token');
    await flush();
    expect(errors.single, isA<LiveConnectException>());
    expect(
      errors.single.toString(),
      allOf(contains('401'), contains('no token')),
    );
    await subscription.cancel();
  });

  test('cancellation before connection aborts the request and prevents late publications', () async {
    final client = getClient(httpClient: answering());
    final subscription = client
        .fetchLive('*')
        .listen((_) => fail('cancelled query emitted'));
    final call = server.live.single;
    await subscription.cancel();
    expect(call.aborted, isTrue);
    final events = call.open();
    events.add(utf8.encode('event: welcome\nid: 1\n\n'));
    await flush();
    expect(events.hasListener, isFalse);
    expect(call.bodyCancelled, isTrue);
    expect(queries, isEmpty);
  });

  test('cancellation stops reconnection', () {
    fakeAsync((async) {
      final client = getClient(httpClient: answering());
      final subscription = client.fetchLive('*').listen((_) {});
      final events = server.live.single.open();
      async.flushMicrotasks();
      unawaited(subscription.cancel());
      unawaited(events.close());
      async.elapse(const Duration(minutes: 1));
      expect(server.live, hasLength(1));
    });
  });

  test(
    'reconnection discards previous requests and resumes from the last event',
    () {
      fakeAsync((async) {
        final client = getClient(httpClient: held());
        final values = <dynamic>[];
        final subscription = client
            .fetchLive('*')
            .listen((response) => values.add(response.result));
        final old = server.live.single.open();
        old.add(utf8.encode('event: welcome\nid: 1\n\n'));
        async.flushMicrotasks();
        expect(requests, hasLength(1));

        unawaited(old.close());
        async.elapse(const Duration(seconds: 3));
        expect(server.live, hasLength(2));
        expect(server.live.last.request.headers['Last-Event-ID'], '1');
        final next = server.live.last.open();
        next.add(utf8.encode('event: welcome\nid: 2\n\n'));
        async.flushMicrotasks();

        requests.first.complete(response('old'));
        async.flushMicrotasks();
        expect(values, isEmpty);
        expect(requests, hasLength(2));
        requests.last.complete(response('new'));
        async.flushMicrotasks();
        expect(values, ['new']);
        unawaited(subscription.cancel());
        async.flushMicrotasks();
        expect(next.hasListener, isFalse);
      });
    },
  );
}
