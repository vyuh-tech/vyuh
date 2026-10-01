import 'dart:async';
import 'dart:convert';

import 'package:eventflux/eventflux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sanity_client/sanity_client.dart';

import 'util.dart';

class TestFlux extends Fake implements EventFlux {
  Function(EventFluxResponse?)? connected;
  Function(EventFluxException)? failed;
  int disconnects = 0;
  @override
  void connect(
    EventFluxConnectionType type,
    String url, {
    required Function(EventFluxResponse?) onSuccessCallback,
    Map<String, String> header = const {'Accept': 'text/event-stream'},
    Function()? onConnectionClose,
    bool autoReconnect = false,
    ReconnectConfig? reconnectConfig,
    Function(EventFluxException)? onError,
    HttpClientAdapter? httpClient,
    Map<String, dynamic>? body,
    String? tag,
    bool logReceivedData = false,
    List<http.MultipartFile>? files,
    bool multipartRequest = false,
  }) {
    connected = onSuccessCallback;
    failed = onError;
  }

  @override
  Future<EventFluxStatus> disconnect() async {
    disconnects++;
    return EventFluxStatus.disconnected;
  }
}

http.Response response(String value) => http.Response(
    jsonEncode({
      'result': value,
      'ms': 1,
      'query': '*',
      'syncTags': ['tag']
    }),
    200);
Future<void> flush() => Future<void>.delayed(Duration.zero);
void main() {
  late TestFlux flux;
  setUp(() {
    flux = TestFlux();
    SanityConfig.createEventFlux = () => flux;
  });
  tearDown(() {
    SanityConfig.createEventFlux = EventFlux.spawn;
  });
  test('bursts coalesce and suppress an obsolete result', () async {
    final requests = <Completer<http.Response>>[];
    final client = getClient(httpClient: MockClient((_) {
      final response = Completer<http.Response>();
      requests.add(response);
      return response.future;
    }));
    final values = <dynamic>[];
    final events = StreamController<EventFluxData>(sync: true);
    final subscription =
        client.fetchLive('*').listen((response) => values.add(response.result));
    flux.connected!(EventFluxResponse(
        status: EventFluxStatus.connected, stream: events.stream));
    events.add(EventFluxData(data: '', id: '1', event: 'welcome'));
    await flush();
    events.add(EventFluxData(data: '', id: '2', event: 'restart'));
    events.add(EventFluxData(data: '', id: '3', event: 'restart'));
    expect(requests, hasLength(1));
    requests.first.complete(response('old'));
    await flush();
    expect(requests, hasLength(2));
    expect(values, isEmpty);
    requests.last.complete(response('new'));
    await flush();
    expect(values, ['new']);
    await subscription.cancel();
    expect(flux.disconnects, 1);
    await events.close();
  });
  test('connection and malformed event errors reach the subscriber', () async {
    final errors = <Object>[];
    final client =
        getClient(httpClient: MockClient((_) async => response('value')));
    final subscription =
        client.fetchLive('*').listen((_) {}, onError: errors.add);
    flux.failed!(EventFluxException(message: 'offline'));
    await flush();
    expect(errors.last, isA<LiveConnectException>());
    errors.clear();
    flux.connected!(null);
    await flush();
    expect(errors.single, isA<LiveConnectException>());
    final events = StreamController<EventFluxData>(sync: true);
    flux.connected!(EventFluxResponse(
        status: EventFluxStatus.connected, stream: events.stream));
    events.add(EventFluxData(data: '{bad', id: '1', event: ''));
    await flush();
    expect(errors.last, isA<FormatException>());
    await subscription.cancel();
    await events.close();
  });
  test(
      'cancellation before connection prevents subscriptions and late publications',
      () async {
    final client =
        getClient(httpClient: MockClient((_) async => response('value')));
    final events = StreamController<EventFluxData>.broadcast();
    final subscription =
        client.fetchLive('*').listen((_) => fail('cancelled query emitted'));
    await subscription.cancel();
    flux.connected!(EventFluxResponse(
        status: EventFluxStatus.connected, stream: events.stream));
    expect(events.hasListener, isFalse);
    expect(flux.disconnects, greaterThanOrEqualTo(1));
    await events.close();
  });
  test(
      'reconnection discards previous requests and cancels the old event stream',
      () async {
    final requests = <Completer<http.Response>>[];
    final client = getClient(httpClient: MockClient((_) {
      final response = Completer<http.Response>();
      requests.add(response);
      return response.future;
    }));
    final values = <dynamic>[];
    final old = StreamController<EventFluxData>(sync: true),
        next = StreamController<EventFluxData>(sync: true);
    final subscription =
        client.fetchLive('*').listen((response) => values.add(response.result));
    flux.connected!(EventFluxResponse(
        status: EventFluxStatus.connected, stream: old.stream));
    old.add(EventFluxData(data: '', id: '1', event: 'welcome'));
    await flush();
    flux.connected!(EventFluxResponse(
        status: EventFluxStatus.connected, stream: next.stream));
    next.add(EventFluxData(data: '', id: '2', event: 'welcome'));
    requests.first.complete(response('old'));
    await flush();
    expect(old.hasListener, isFalse);
    expect(values, isEmpty);
    requests.last.complete(response('new'));
    await flush();
    expect(values, ['new']);
    await subscription.cancel();
    await old.close();
    await next.close();
  });
}
