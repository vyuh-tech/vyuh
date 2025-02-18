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
  /// Fetches data from Sanity using Server-Sent Events (SSE) for live updates.
  Stream<SanityQueryResponse> fetchLive(
    String query, {
    Map<String, String>? params,
  }) {
    final sanityRequest = SanityRequest(
      urlBuilder: urlBuilder,
      query: query,
      params: {
        if (params != null) ...params,
        if (config.perspective == Perspective.previewDrafts)
          'includeDrafts': 'true',
      },
      live: true,
    );

    final uri = sanityRequest.getUri;

    final headers = Map<String, String>.from(_requestHeaders);
    headers['Accept'] = 'text/event-stream';

    final controller = StreamController<SanityQueryResponse>();

    EventFlux.instance.connect(
      EventFluxConnectionType.get,
      uri.toString(),
      autoReconnect: true,
      reconnectConfig: ReconnectConfig(
        mode: ReconnectMode.exponential,
        maxAttempts: 5,
      ),
      header: headers,
      httpClient: _EventFluxHttpClientAdapter(httpClient: httpClient),
      tag: query,
      onSuccessCallback: (response) {
        if (response == null || response.stream == null) {
          throw LiveConnectException('With query: $query, params: $params');
        }

        _onLiveConnectCallback(controller, query, params, response.stream!);
      },
      onError: (error) {
        throw LiveConnectException('With query: $query, params: $params');
      },
    );

    return controller.stream;
  }

  void _onLiveConnectCallback(
    StreamController<SanityQueryResponse> controller,
    String query,
    Map<String, String>? params,
    Stream<EventFluxData> stream,
  ) async {
    late final StreamSubscription<EventFluxData> subscription;

    controller.onCancel = () {
      subscription.cancel();
      EventFlux.instance.disconnect();
    };

    fetchQuery() async {
      try {
        final response = await fetch(query, params: params);
        controller.add(response);
      } catch (e, stackTrace) {
        controller.addError(e, stackTrace);
      }
    }

    listener(event) async {
      if (controller.isClosed) {
        subscription.cancel();
        return;
      }

      final eventType = _LiveEventType.fromEvent(event);

      switch (eventType) {
        case _LiveEventType.welcome || _LiveEventType.restart:
          fetchQuery();
          break;

        case _LiveEventType.message:
          final eventData = jsonDecode(event.data);
          if (eventData != null && eventData['tags'] != null) {
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
