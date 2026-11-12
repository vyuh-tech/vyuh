import 'dart:async';
import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sanity_client/src/live_event_source.dart';

import 'util.dart';

List<LiveEvent> parse(String text) {
  final parser = LiveEventParser();
  return [
    for (final line in const LineSplitter().convert(text))
      ?parser.addLine(line),
  ];
}

void main() {
  group('LiveEventParser', () {
    test('an event carries its event, id and data fields', () {
      final event = parse('event: welcome\nid: 7\ndata: hello\n\n').single;
      expect((event.event, event.id, event.data), ('welcome', '7', 'hello'));
    });

    test('several data lines are joined with a newline', () {
      final event = parse('data: {\ndata:   "a": 1\ndata: }\n\n').single;
      expect(event.data, '{\n  "a": 1\n}');
      expect(jsonDecode(event.data), {'a': 1});
    });

    test('only one leading space of a value is removed', () {
      expect(parse('data:  two\n\n').single.data, ' two');
      expect(parse('data:none\n\n').single.data, 'none');
    });

    test('a field without a colon has an empty value', () {
      final event = parse('data\nevent: x\n\n').single;
      expect((event.event, event.data), ('x', ''));
    });

    test('an event with no data is still delivered', () {
      final event = parse('event: welcome\nid: 1\n\n').single;
      expect((event.event, event.id, event.data), ('welcome', '1', ''));
    });

    test('comments, keep-alives and unknown fields produce nothing', () {
      expect(
        parse(': keep-alive\n\n:\n\n\n\nretry: 500\nfoo: bar\n\n'),
        isEmpty,
      );
    });

    test('a comment inside an event does not split it', () {
      final event = parse('event: a\n: ping\ndata: b\n\n').single;
      expect((event.event, event.data), ('a', 'b'));
    });

    test('events are separated by blank lines, with any line ending', () {
      final events = parse('id: 1\r\ndata: a\r\n\r\nid: 2\rdata: b\r\r');
      expect(events.map((e) => '${e.id}:${e.data}'), ['1:a', '2:b']);
    });

    test('an event without an id has an empty id; the last id is kept', () {
      final parser = LiveEventParser();
      final events = [
        for (final line in ['id: 5', 'data: a', '', 'data: b', ''])
          ?parser.addLine(line),
      ];
      expect(events.map((e) => e.id), ['5', '']);
      expect(parser.lastEventId, '5');
    });

    test('an id holding a NUL character is ignored', () {
      final parser = LiveEventParser()..addLine('id: 1');
      parser.addLine('id: a\u0000b');
      expect(parser.lastEventId, '1');
    });

    test('an unfinished event is dropped on reset', () {
      final parser = LiveEventParser()
        ..addLine('id: 3')
        ..addLine('data: partial')
        ..reset();
      expect(parser.addLine(''), isNull);
      expect(parser.lastEventId, '3');
    });
  });

  group('LiveEventSource', () {
    late LiveHttp server;
    late List<LiveEvent> events;
    late List<Object> errors;
    late int connections;

    LiveEventSource source({int maxReconnectAttempts = 5}) => LiveEventSource(
      httpClient: server,
      uri: Uri.parse('https://example.test/live'),
      headers: const {'Accept': 'text/event-stream', 'Authorization': 'x'},
      maxReconnectAttempts: maxReconnectAttempts,
      onConnected: (stream) {
        connections++;
        stream.listen(events.add);
      },
      onError: errors.add,
    );

    setUp(() {
      server = LiveHttp();
      events = [];
      errors = [];
      connections = 0;
    });

    test('sends a GET with the given headers and delivers events', () async {
      final live = source()..connect();
      final call = server.live.single;
      expect(call.request.method, 'GET');
      expect(call.request.headers['Accept'], 'text/event-stream');
      expect(call.request.headers['Authorization'], 'x');
      expect(call.request.headers.containsKey('Last-Event-ID'), isFalse);
      final body = call.open();
      await flush();
      expect(connections, 1);
      body.add(
        utf8.encode('event: welcome\nid: 1\n\n: ping\n\ndata: {"a":1}\n\n'),
      );
      await flush();
      expect(events.map((e) => '${e.event}|${e.id}|${e.data}'), [
        'welcome|1|',
        '||{"a":1}',
      ]);
      expect(errors, isEmpty);
      await live.close();
    });

    test('an event and a UTF-8 character may be split across chunks', () async {
      final live = source()..connect();
      final body = server.live.single.open();
      await flush();
      final bytes = utf8.encode('id: 9\ndata: caf\u00e9\n\n');
      final cut = bytes.indexOf(0xc3) + 1;
      body.add(bytes.sublist(0, cut));
      await flush();
      expect(events, isEmpty);
      body.add(bytes.sublist(cut));
      await flush();
      expect(events.single.data, 'caf\u00e9');
      await live.close();
    });

    test('close cancels the response stream and stops delivery', () async {
      final live = source()..connect();
      final body = server.live.single.open();
      await flush();
      expect(body.hasListener, isTrue);
      await live.close();
      expect(body.hasListener, isFalse);
      expect(server.live.single.bodyCancelled, isTrue);
      expect(events, isEmpty);
      expect(errors, isEmpty);
    });

    test('close before the response aborts the request', () async {
      final live = source()..connect();
      final call = server.live.single;
      expect(call.aborted, isFalse);
      await live.close();
      expect(call.aborted, isTrue);
      call.fail(http.RequestAbortedException(call.request.url));
      await flush();
      expect(errors, isEmpty);
      expect(connections, 0);
    });

    test('a response that arrives after close is released unread', () async {
      final live = source()..connect();
      final call = server.live.single;
      await live.close();
      final body = call.open();
      await flush();
      expect(connections, 0);
      expect(call.bodyCancelled, isTrue);
      expect(body.hasListener, isFalse);
    });

    test('a closed source does not reconnect', () {
      fakeAsync((async) {
        final live = source()..connect();
        final body = server.live.single.open();
        async.flushMicrotasks();
        unawaited(live.close());
        unawaited(body.close());
        async.elapse(const Duration(minutes: 1));
        expect(server.live, hasLength(1));
      });
    });

    test('a stream that ends reconnects with the last event id', () {
      fakeAsync((async) {
        source().connect();
        final body = server.live.single.open();
        async.flushMicrotasks();
        body.add(
          utf8.encode('id: 41\ndata: a\n\nid: 42\ndata: b\n\ndata: c\n\n'),
        );
        unawaited(body.close());
        async.flushMicrotasks();
        expect(server.live, hasLength(1));
        async.elapse(const Duration(milliseconds: 1999));
        expect(server.live, hasLength(1));
        async.elapse(const Duration(milliseconds: 501));
        expect(server.live, hasLength(2));
        expect(server.live.last.request.headers['Last-Event-ID'], '42');
        expect(server.live.last.request.headers['Authorization'], 'x');
        server.live.last.open();
        async.flushMicrotasks();
        expect(connections, 2);
        expect(errors, isEmpty);
      });
    });

    test('a half-received event is not carried into the next connection', () {
      fakeAsync((async) {
        source().connect();
        final first = server.live.single.open();
        async.flushMicrotasks();
        first.add(utf8.encode('event: restart\ndata: half'));
        unawaited(first.close());
        async.elapse(const Duration(seconds: 3));
        final second = server.live.last.open();
        async.flushMicrotasks();
        second.add(utf8.encode('data: whole\n\n'));
        async.flushMicrotasks();
        expect(events.map((e) => '${e.event}|${e.data}'), ['|whole']);
      });
    });

    test('a failed connection reports the error and retries', () {
      fakeAsync((async) {
        source().connect();
        server.live.single.fail(http.ClientException('offline'));
        async.flushMicrotasks();
        expect(errors.single.toString(), contains('offline'));
        async.elapse(const Duration(seconds: 3));
        expect(server.live, hasLength(2));
      });
    });

    test('a broken stream reports the error and retries', () {
      fakeAsync((async) {
        source().connect();
        final body = server.live.single.open();
        async.flushMicrotasks();
        body.addError(http.ClientException('reset'));
        async.flushMicrotasks();
        expect(errors.single.toString(), contains('reset'));
        expect(body.hasListener, isFalse);
        async.elapse(const Duration(seconds: 3));
        expect(server.live, hasLength(2));
      });
    });

    test('it gives up after the allowed attempts in a row', () {
      fakeAsync((async) {
        source(maxReconnectAttempts: 2).connect();
        for (var i = 0; i < 5; i++) {
          if (server.live.length > i) {
            server.live[i].fail(http.ClientException('offline'));
          }
          async.elapse(const Duration(seconds: 3));
        }
        expect(server.live, hasLength(3));
        expect(errors, hasLength(3));
      });
    });

    test('a successful connection restores the allowed attempts', () {
      fakeAsync((async) {
        source(maxReconnectAttempts: 1).connect();
        for (var i = 0; i < 4; i++) {
          unawaited(server.live[i].open().close());
          async.elapse(const Duration(seconds: 3));
        }
        expect(server.live, hasLength(5));
      });
    });

    for (final status in [500, 503, 408, 429]) {
      test('status $status reports the error and retries', () {
        fakeAsync((async) {
          source().connect();
          server.live.single.open(status: status, body: 'busy');
          async.flushMicrotasks();
          expect(
            errors.single.toString(),
            allOf(contains('$status'), contains('busy')),
          );
          expect(connections, 0);
          async.elapse(const Duration(seconds: 3));
          expect(server.live, hasLength(2));
        });
      });
    }

    for (final status in [400, 401, 403, 404]) {
      test('status $status reports the error and does not retry', () {
        fakeAsync((async) {
          source().connect();
          server.live.single.open(status: status, body: 'no');
          async.flushMicrotasks();
          expect(errors.single.toString(), contains('$status'));
          async.elapse(const Duration(minutes: 1));
          expect(server.live, hasLength(1));
        });
      });
    }

    test(
      'a response that is not an event stream is refused, without retry',
      () {
        fakeAsync((async) {
          source().connect();
          final call = server.live.single;
          final body = call.open(contentType: 'text/html');
          async.flushMicrotasks();
          expect(errors.single.toString(), contains('text/html'));
          expect(connections, 0);
          expect(call.bodyCancelled, isTrue);
          expect(body.hasListener, isFalse);
          async.elapse(const Duration(minutes: 1));
          expect(server.live, hasLength(1));
        });
      },
    );

    test('connect is ignored while connected and after close', () async {
      final live = source()
        ..connect()
        ..connect();
      expect(server.live, hasLength(1));
      await live.close();
      live.connect();
      expect(server.live, hasLength(1));
    });
  });
}
