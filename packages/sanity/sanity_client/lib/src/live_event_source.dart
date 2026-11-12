import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

/// One server-sent event.
final class LiveEvent {
  /// Creates an event from its three fields.
  const LiveEvent({required this.id, required this.event, required this.data});

  /// The `id` field of this event, or an empty string when it has none.
  final String id;

  /// The `event` field, or an empty string when it has none.
  final String event;

  /// The `data` lines joined with a newline, or an empty string.
  final String data;
}

/// Turns the lines of a `text/event-stream` body into events.
///
/// Feed it one line at a time, without the line ending. A blank line ends an
/// event. A line that starts with a colon is a comment, and comments, unknown
/// fields and blank lines with nothing before them produce no event.
final class LiveEventParser {
  String _id = '';
  String _event = '';
  final _data = <String>[];
  bool _started = false;

  /// The most recent `id` seen. It survives [reset], so that a reconnect can
  /// tell the server where to resume.
  String lastEventId = '';

  /// Takes the next line and returns the event it completes, if any.
  LiveEvent? addLine(String line) {
    if (line.isEmpty) {
      if (!_started) return null;
      final event = LiveEvent(id: _id, event: _event, data: _data.join('\n'));
      reset();
      return event;
    }
    if (line.startsWith(':')) return null;
    final colon = line.indexOf(':');
    final field = colon < 0 ? line : line.substring(0, colon);
    var value = colon < 0 ? '' : line.substring(colon + 1);
    if (value.startsWith(' ')) value = value.substring(1);
    switch (field) {
      case 'event':
        _event = value;
        _started = true;
      case 'data':
        _data.add(value);
        _started = true;
      case 'id':
        if (!value.contains('\u0000')) {
          _id = value;
          lastEventId = value;
          _started = true;
        }
    }
    return null;
  }

  /// Drops an unfinished event. Call it when a connection ends.
  void reset() {
    _id = '';
    _event = '';
    _data.clear();
    _started = false;
  }
}

/// A server-sent event connection over an [http.Client].
///
/// [connect] sends one GET and hands the events of each successful connection
/// to [onConnected] as a stream that closes when that connection ends. When a
/// connection fails or ends it reconnects after [reconnectInterval] plus up to
/// a quarter of it, at most [maxReconnectAttempts] times in a row; a
/// successful connection restores the count. A reconnect sends the last event
/// id in the `Last-Event-ID` header. A status other than 200 is retried only
/// for 408, 429 and 5xx, and a response that is not `text/event-stream` is not
/// retried. Every failure is passed to [onError].
///
/// [close] aborts a pending request, cancels the response stream, which closes
/// the connection, and stops reconnecting. A closed source stays closed.
///
/// The response is read as it arrives, so the client must stream response
/// bodies. `IOClient` does, and `BrowserClient` does from `http` 1.3.0 (fetch),
/// with cancellation of a waiting read fixed in 1.6.0.
final class LiveEventSource {
  /// Creates a source. Nothing is sent until [connect].
  LiveEventSource({
    required this.httpClient,
    required this.uri,
    required this.headers,
    required this.onConnected,
    required this.onError,
    this.reconnectInterval = const Duration(seconds: 2),
    this.maxReconnectAttempts = 5,
    Random? random,
  }) : _random = random ?? Random(),
       _attemptsLeft = maxReconnectAttempts;

  /// The client that sends the request. It is not closed by [close].
  final http.Client httpClient;

  /// The address of the event stream.
  final Uri uri;

  /// The headers sent with every request.
  final Map<String, String> headers;

  /// Called with the events of each successful connection.
  final void Function(Stream<LiveEvent> events) onConnected;

  /// Called with every connection or stream failure.
  final void Function(Object error) onError;

  /// The wait before a reconnect, before jitter.
  final Duration reconnectInterval;

  /// How many reconnects in a row are tried before giving up.
  final int maxReconnectAttempts;

  final Random _random;
  final _parser = LiveEventParser();
  int _attemptsLeft;
  bool _connecting = false;
  bool _closed = false;
  Completer<void>? _abort;
  Timer? _retry;
  StreamSubscription<String>? _lines;
  StreamController<LiveEvent>? _events;

  /// Opens the connection. It does nothing if already called or after [close].
  void connect() {
    if (_connecting || _closed) return;
    _connecting = true;
    unawaited(_open());
  }

  /// Ends the connection and stops reconnecting.
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _retry?.cancel();
    _retry = null;
    final abort = _abort;
    _abort = null;
    if (abort != null && !abort.isCompleted) abort.complete();
    final lines = _lines;
    _lines = null;
    _endEvents();
    try {
      await lines?.cancel();
    } on http.ClientException {
      // Cancelling a browser read that already failed rethrows that failure.
      // The connection is gone either way.
    }
  }

  Future<void> _open() async {
    final abort = _abort = Completer<void>();
    final request = http.AbortableRequest(
      'GET',
      uri,
      abortTrigger: abort.future,
    )..headers.addAll(headers);
    if (_parser.lastEventId.isNotEmpty) {
      request.headers['Last-Event-ID'] = _parser.lastEventId;
    }

    final http.StreamedResponse response;
    try {
      response = await httpClient.send(request);
    } catch (error) {
      if (_closed) return;
      _abort = null;
      onError(error);
      _reconnect();
      return;
    }
    if (_closed) return _release(response);
    _abort = null;

    if (response.statusCode != 200) {
      final failure = await _failure(response);
      if (_closed) return;
      onError(failure);
      final status = response.statusCode;
      if (status >= 500 || status == 408 || status == 429) _reconnect();
      return;
    }
    final contentType = response.headers['content-type'] ?? '';
    if (!contentType.contains('text/event-stream')) {
      _release(response);
      onError('Expected content-type text/event-stream, got "$contentType"');
      return;
    }

    _attemptsLeft = maxReconnectAttempts;
    _parser.reset();
    final events = _events = StreamController<LiveEvent>();
    onConnected(events.stream);
    if (_closed) return _release(response);
    _lines = response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          (line) {
            final event = _parser.addLine(line);
            if (event != null && !events.isClosed) events.add(event);
          },
          onError: (Object error) {
            _lines = null;
            _endEvents();
            if (_closed) return;
            onError(error);
            _reconnect();
          },
          onDone: () {
            _lines = null;
            _endEvents();
            _reconnect();
          },
          cancelOnError: true,
        );
  }

  void _reconnect() {
    _parser.reset();
    if (_closed || _attemptsLeft <= 0) return;
    _attemptsLeft--;
    final jitter = reconnectInterval * (_random.nextDouble() * 0.25);
    _retry = Timer(reconnectInterval + jitter, () {
      _retry = null;
      if (!_closed) unawaited(_open());
    });
  }

  void _endEvents() {
    final events = _events;
    _events = null;
    if (events != null) unawaited(events.close());
  }

  /// Lets go of a response nobody will read, so its connection is closed.
  void _release(http.StreamedResponse response) {
    unawaited(
      response.stream
          .listen(null, onError: (Object _) {})
          .cancel()
          .catchError((Object _) {}),
    );
  }

  Future<String> _failure(http.StreamedResponse response) async {
    var body = '';
    try {
      body = await response.stream.bytesToString();
    } on Exception {
      // The status alone describes the failure.
    }
    return [
      'HTTP ${response.statusCode}',
      if (response.reasonPhrase case final reason? when reason.isNotEmpty)
        reason,
      if (body.isNotEmpty) body,
    ].join(' ');
  }
}
