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

typedef _ConnectionConfig = ({
  LiveConfig liveConfig,
  StreamController<SanityQueryResponse> controller,
  EventFlux flux,
  Stream<EventFluxData> stream,
});

extension LiveConnect on SanityClient {
  /// Fetches data from Sanity using Server-Sent Events (SSE) for live updates.
  ///
  /// [includeDrafts] whe true it will also listen to draft changes.
  Stream<SanityQueryResponse> fetchLive(
    String query, {
    Map<String, String>? params,
    includeDrafts = false,
  }) {
    assert(
      includeDrafts
          ? config.perspective == Perspective.drafts && !config.useCdn
          : true,
      'When includeDrafts is true, the config must have perspective set to previewDrafts and useCdn set to false',
    );

    final liveConfig = includeDrafts ? LiveConfig.withDrafts() : LiveConfig();
    final sanityRequest = SanityRequest(
      urlBuilder: urlBuilder,
      query: '',
      live: liveConfig,
    );

    final uri = sanityRequest.getUri;

    final headers = Map<String, String>.from(_requestHeaders);
    headers['Accept'] = 'text/event-stream';

    final controller = StreamController<SanityQueryResponse>();

    final flux = SanityConfig.createEventFlux();

    flux.connect(
      EventFluxConnectionType.get,
      uri.toString(),
      autoReconnect: true,
      reconnectConfig: ReconnectConfig(
        mode: ReconnectMode.linear,
        maxAttempts: 5,
        onReconnect: () => debugPrint('Reconnected to Live API'),
      ),
      header: headers,
      httpClient: _EventFluxHttpClientAdapter(httpClient: httpClient),
      tag: query,
      onSuccessCallback: (response) {
        if (response == null || response.stream == null) {
          throw LiveConnectException('With query: $query, params: $params');
        }

        _onLiveConnectCallback(query, params, config: (
          liveConfig: liveConfig,
          controller: controller,
          stream: response.stream!,
          flux: flux,
        ));
      },
      onError: (error) {
        controller.close();
        throw LiveConnectException(
            'With query: $query, params: $params, error: $error');
      },
    );

    return controller.stream;
  }

  void _onLiveConnectCallback(String query, Map<String, String>? params,
      {required _ConnectionConfig config}) async {
    late final StreamSubscription<EventFluxData> subscription;
    String? lastEventId;
    List<String> syncTags = [];

    final (
      controller: controller,
      liveConfig: liveConfig,
      flux: flux,
      stream: stream
    ) = config;

    controller.onCancel = () {
      subscription.cancel();
      flux.disconnect();
    };

    fetchQuery() async {
      try {
        final allParams = {
          if (params != null) ...params,
          'lastLiveEventId': lastEventId ?? '',
        };

        final response = await fetch(query, params: allParams);

        // Track the syncTags to check with an update
        syncTags = response.syncTags;

        controller.add(response);
      } catch (e, stackTrace) {
        controller.addError(e, stackTrace);
      }
    }

    listener(event) async {
      if (controller.isClosed) {
        subscription.cancel();
        flux.disconnect();
        return;
      }

      final eventType = _LiveEventType.fromEvent(event);

      switch (eventType) {
        case _LiveEventType.welcome || _LiveEventType.restart:
          lastEventId = event.id;
          fetchQuery();
          break;

        case _LiveEventType.message:
          lastEventId = event.id;

          final eventData = jsonDecode(event.data);
          final tags = (eventData?['tags'] as List?)?.cast<String>();

          final canUpdate = tags?.any((tag) => syncTags.contains(tag)) ?? false;
          if (canUpdate) {
            fetchQuery();
          }

          break;

        case _LiveEventType.error:
          controller.addError('Live Data error');
          break;

        default:
          break;
      }
    }

    subscription = stream.listen(listener);
  }
}

final class _EventFluxHttpClientAdapter implements HttpClientAdapter {
  final http.Client httpClient;

  _EventFluxHttpClientAdapter({required this.httpClient});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      httpClient.send(request);
}
