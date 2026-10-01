part of 'client.dart';

enum _LiveEventType {
  welcome,
  restart,
  error,
  keepAlive,
  message;

  static _LiveEventType fromEvent(EventFluxData event) => switch (event.event) {
        'welcome' => _LiveEventType.welcome,
        'restart' => _LiveEventType.restart,
        'error' => _LiveEventType.error,
        '' => event.data.isEmpty
            ? _LiveEventType.keepAlive
            : _LiveEventType.message,
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
          'Draft live queries require the drafts perspective without CDN');
    }
    final liveConfig = includeDrafts ? LiveConfig.withDrafts() : LiveConfig();
    final uri =
        SanityRequest(urlBuilder: urlBuilder, query: '', live: liveConfig)
            .getUri;
    final headers = Map<String, String>.from(_requestHeaders)
      ..['Accept'] = 'text/event-stream';
    final flux = SanityConfig.createEventFlux();
    late final StreamController<SanityQueryResponse> controller;
    StreamSubscription<EventFluxData>? subscription;
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
            final response = await fetch(query, params: {
              if (params != null) ...params,
              'lastLiveEventId': lastEventId ?? '',
            });
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

    void listener(EventFluxData event) {
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

    controller = StreamController<SanityQueryResponse>(
      onListen: () {
        try {
          flux.connect(
            EventFluxConnectionType.get,
            uri.toString(),
            autoReconnect: true,
            reconnectConfig:
                ReconnectConfig(mode: ReconnectMode.linear, maxAttempts: 5),
            header: headers,
            httpClient: _EventFluxHttpClientAdapter(httpClient: httpClient),
            tag: query,
            onSuccessCallback: (response) {
              if (cancelled) {
                flux.disconnect();
                return;
              }
              final stream = response?.stream;
              if (stream == null) {
                report(
                    LiveConnectException('No live stream for query: $query'));
                return;
              }
              generation++;
              syncTags = null;
              final connectionGeneration = generation;
              unawaited(subscription?.cancel());
              subscription = stream.listen(
                (event) {
                  if (connectionGeneration == generation) listener(event);
                },
                onError: (Object error, StackTrace stack) {
                  if (connectionGeneration == generation) report(error, stack);
                },
              );
              if (fetching) pending = true;
            },
            onError: (error) =>
                report(LiveConnectException('Live connection failed: $error')),
          );
        } catch (error, stack) {
          report(error, stack);
        }
      },
      onCancel: () async {
        cancelled = true;
        generation++;
        pending = false;
        try {
          await subscription?.cancel();
        } finally {
          await flux.disconnect();
        }
      },
    );
    return controller.stream;
  }
}

final class _EventFluxHttpClientAdapter implements HttpClientAdapter {
  final http.Client httpClient;

  _EventFluxHttpClientAdapter({required this.httpClient});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      httpClient.send(request);
}
