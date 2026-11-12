@TestOn('vm')
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sanity_client/src/live_event_source.dart';

/// The real `IOClient` against a loopback server: the body is read while the
/// response is still open, and closing the source closes the connection.
void main() {
  late HttpServer server;
  late http.Client client;

  setUp(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    client = http.Client();
  });

  tearDown(() async {
    client.close();
    await server.close(force: true);
  });

  test('events arrive while the response is open, and close ends it', () async {
    final disconnected = Completer<void>();
    final requests = <HttpRequest>[];
    server.listen((request) {
      requests.add(request);
      final response = request.response
        ..bufferOutput = false
        ..headers.contentType = ContentType('text', 'event-stream')
        ..write('event: welcome\nid: 1\n\n');
      unawaited(
        response.done.then<void>(
          (_) => disconnected.complete(),
          onError: (Object _) => disconnected.complete(),
        ),
      );
      Timer(const Duration(milliseconds: 50), () {
        response.write(
          ': keep-alive\n\nid: 2\ndata: {"tags":\ndata: ["a"]}\n\n',
        );
      });
    });

    final events = <LiveEvent>[];
    final errors = <Object>[];
    final second = Completer<void>();
    final source = LiveEventSource(
      httpClient: client,
      uri: Uri.parse('http://${server.address.host}:${server.port}/live'),
      headers: const {'Accept': 'text/event-stream'},
      onConnected: (stream) => stream.listen((event) {
        events.add(event);
        if (events.length == 2) second.complete();
      }),
      onError: errors.add,
    )..connect();

    await second.future.timeout(const Duration(seconds: 5));
    expect(events.map((e) => '${e.event}|${e.id}|${e.data}'), [
      'welcome|1|',
      '|2|{"tags":\n["a"]}',
    ]);
    expect(requests.single.headers.value('accept'), 'text/event-stream');
    expect(disconnected.isCompleted, isFalse);

    await source.close();
    // The server only notices a closed socket when it next writes.
    final poke = Timer.periodic(const Duration(milliseconds: 20), (_) {
      if (!disconnected.isCompleted) requests.single.response.write(':\n\n');
    });
    await disconnected.future.timeout(const Duration(seconds: 5));
    poke.cancel();
    expect(errors, isEmpty);
    expect(requests, hasLength(1));
  });
}
