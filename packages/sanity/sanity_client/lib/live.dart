part of 'client.dart';

enum _LiveEventType {
  welcome,
  restart,
  error,
  keepAlive,
  message;

  static _LiveEventType fromEvent(LiveEvent event) => switch (event.event) {
    'welcome' => _LiveEventType.welcome,
    'restart' => _LiveEventType.restart,
    'error' => _LiveEventType.error,
    '' =>
      event.data.isEmpty ? _LiveEventType.keepAlive : _LiveEventType.message,
    _ => _LiveEventType.keepAlive,
  };
}

extension LiveConnect on SanityClient {
  /// Fetches live query results. Requests are serialized and bursts coalesced.
  /// Errors are delivered through the returned stream; cancelling disconnects SSE.
  Stream<SanityQueryResponse> fetchLive(
    String query, {
    Map<String, String>? params,
    bool includeDrafts = false,
  }) {
    if (includeDrafts &&
        (config.perspective != Perspective.drafts || config.useCdn)) {
      throw ArgumentError(
        'Draft live queries require the drafts perspective without CDN',
      );
    }
    final liveConfig = includeDrafts ? LiveConfig.withDrafts() : LiveConfig();
    final uri = SanityRequest(
      urlBuilder: urlBuilder,
      query: '',
      live: liveConfig,
    ).getUri;
    final headers = Map<String, String>.from(_requestHeaders)
      ..['Accept'] = 'text/event-stream';
    late final StreamController<SanityQueryResponse> controller;
    late final LiveEventSource source;
    StreamSubscription<LiveEvent>? subscription;
    var cancelled = false;
    var generation = 0;
    var fetching = false;
    var pending = false;
    String? lastEventId;
    List<String>? syncTags;

    void report(Object error, [StackTrace? stack]) {
      if (!cancelled && !controller.isClosed) controller.addError(error, stack);
    }

    Future<void> fetchQuery() async {
      pending = true;
      if (fetching) return;
      fetching = true;
      try {
        while (pending && !cancelled) {
          pending = false;
          final requestGeneration = generation;
          try {
            final response = await fetch(
              query,
              params: {...?params, 'lastLiveEventId': lastEventId ?? ''},
            );
            if (!cancelled && requestGeneration == generation && !pending) {
              syncTags = response.syncTags;
              controller.add(response);
            }
          } catch (error, stack) {
            if (requestGeneration == generation && !pending) {
              report(error, stack);
            }
          }
        }
      } finally {
        fetching = false;
      }
    }

    void listener(LiveEvent event) {
      if (cancelled) return;
      try {
        switch (_LiveEventType.fromEvent(event)) {
          case _LiveEventType.welcome || _LiveEventType.restart:
            lastEventId = event.id;
            unawaited(fetchQuery());
          case _LiveEventType.message:
            lastEventId = event.id;
            final data = jsonDecode(event.data) as Map<String, dynamic>;
            final tags = (data['tags'] as List?)?.cast<String>();
            if (syncTags == null || (tags?.any(syncTags!.contains) ?? false)) {
              unawaited(fetchQuery());
            }
          case _LiveEventType.error:
            report(LiveConnectException('Live data error for query: $query'));
          default:
            break;
        }
      } catch (error, stack) {
        report(error, stack);
      }
    }

    source = LiveEventSource(
      httpClient: httpClient,
      uri: uri,
      headers: headers,
      onConnected: (events) {
        if (cancelled) {
          unawaited(source.close());
          return;
        }
        generation++;
        syncTags = null;
        final connectionGeneration = generation;
        unawaited(subscription?.cancel());
        subscription = events.listen((event) {
          if (connectionGeneration == generation) listener(event);
        });
        if (fetching) pending = true;
      },
      onError: (error) =>
          report(LiveConnectException('Live connection failed: $error')),
    );
    controller = StreamController<SanityQueryResponse>(
      onListen: source.connect,
      onCancel: () async {
        cancelled = true;
        generation++;
        pending = false;
        // Closing first stops the connection and any reconnect at once.
        final closed = source.close();
        try {
          await subscription?.cancel();
        } finally {
          await closed;
        }
      },
    );
    return controller.stream;
  }
}
