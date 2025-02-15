import 'dart:async';
import 'dart:convert';

import 'package:eventflux/eventflux.dart';
import 'package:http/http.dart' as http;

import 'sanity_client.dart';
import 'sanity_request.dart';

/// The various perspectives that can be used to fetch data from Sanity
enum Perspective {
  /// Fetch all documents including drafts
  raw,

  /// Fetch drafts as if they were published.
  ///
  /// Note: Queries using the previewDrafts perspective are not cached in the CDN,
  /// and will return an error if [useCdn] is not set to false.
  /// You should always explicitly set [useCdn] to false when using previewDrafts.
  previewDrafts,

  /// Fetch only the published documents
  published,
}

enum LiveEventType {
  welcome,
  restart,
  error,
  keepAlive,
  message;

  static LiveEventType fromString(String event) => switch (event) {
        'welcome' => LiveEventType.welcome,
        'restart' => LiveEventType.restart,
        'error' => LiveEventType.error,
        'message' => LiveEventType.message,
        _ => LiveEventType.keepAlive,
      };
}

/// Configuration for the Sanity client
final class SanityConfig {
  /// The dataset to fetch data from
  final String dataset;

  /// The project id
  final String projectId;

  /// The token to use for authentication
  final String token;

  /// Whether to use the CDN or not
  final bool useCdn;

  /// The API version to use. It follows the format `vYYYY-MM-DD`
  final String apiVersion;

  /// The perspective to use
  final Perspective perspective;

  /// Whether to explain the query or not
  final bool explainQuery;

  /// The default API version to use
  static final String defaultApiVersion = (() {
    final today = DateTime.now();
    final parts = [
      today.year.toString(),
      today.month.toString().padLeft(2, '0'),
      today.day.toString().padLeft(2, '0')
    ].join('-');

    return 'v$parts';
  })();

  /// Creates a new Sanity configuration for fetching documents from a project and dataset
  SanityConfig({
    required this.projectId,
    required this.dataset,
    required this.token,
    String? apiVersion,
    bool? useCdn,
    Perspective? perspective,
    bool? explainQuery,
  })  : useCdn = useCdn ?? true,
        apiVersion = apiVersion ?? defaultApiVersion,
        perspective = perspective ?? Perspective.raw,
        explainQuery = explainQuery ?? false {
    assert(token.trim().isNotEmpty, '''
Invalid Token provided. 
Setup an API token, with Viewer access, in the Sanity Management Console.
Without a valid token you will not be able to fetch data from Sanity.''');

    assert(RegExp(r'^v\d{4}-\d{2}-\d{2}$').hasMatch(this.apiVersion),
        'Invalid API version provided. It should follow the format `vYYYY-MM-DD`');
  }
}

/// The client for fetching data from Sanity
final class SanityClient {
  /// The configuration for the client
  final SanityConfig config;

  /// The HTTP client to use. Generally not needed to be provided.
  /// It can be set during testing or when used in the context of a framework that has its own [http.Client] instance.
  http.Client httpClient;

  /// The URL builder to use. When not provided it uses the default Sanity URL builder
  final UrlBuilder urlBuilder;

  final Map<String, String> _requestHeaders;

  /// Creates a new Sanity client with the provided configuration. Use the optional
  /// parameters to provide a custom HTTP client or URL builder.
  SanityClient(
    this.config, {
    final http.Client? httpClient,
    final UrlBuilder? urlBuilder,
  })  : urlBuilder = urlBuilder ?? SanityUrlBuilder(config),
        httpClient = httpClient ?? http.Client(),
        _requestHeaders = {
          'Authorization': 'Bearer ${config.token}',
          'Accept': 'application/json',
        };

  /// Set the HTTP client to use for fetching data
  setHttpClient(http.Client client) {
    httpClient = client;
  }

  /// Fetches data from Sanity by running the GROQ Query with the passed in parameters
  Future<SanityQueryResponse> fetch(
    String query, {
    Map<String, String>? params,
  }) async {
    final request = SanityRequest(
      urlBuilder: urlBuilder,
      query: query,
      params: params,
    );

    if (request.requiresPost) {
      return _executePost(request);
    }
    return _executeGet(request);
  }

  /// Fetches data from Sanity using Server-Sent Events (SSE) for live updates.
  Stream<SanityQueryResponse> fetchLive(
    String query, {
    Map<String, String>? params,
  }) {
    final sanityRequest = SanityRequest(
      urlBuilder: urlBuilder,
      query: query,
      params: params,
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
    subscription = stream.listen((event) async {
      if (controller.isClosed) {
        subscription.cancel();
        return;
      }

      final eventType = LiveEventType.fromString(event.event);

      switch (eventType) {
        case LiveEventType.error:
          controller.addError('Live Data error');
          break;

        case LiveEventType.message:
          // Handle query invalidation based on tags
          final eventData = jsonDecode(event.data);
          if (eventData != null && eventData['tags'] != null) {
            try {
              final response = await fetch(query, params: params);
              controller.add(response);
            } catch (e, stackTrace) {
              controller.addError(e, stackTrace);
            }
          }
          break;

        default:
          // For welcome, restart, mutation, keepAlive - fetch latest data
          try {
            final response = await fetch(query, params: params);
            controller.add(response);
          } catch (e, stackTrace) {
            controller.addError(e, stackTrace);
          }
          break;
      }
    });

    controller.onCancel = () {
      subscription.cancel();
      EventFlux.instance.disconnect();
    };
  }

  Future<SanityQueryResponse> _executeGet(SanityRequest request) async {
    final response = await httpClient.get(
      request.getUri,
      headers: _requestHeaders,
    );

    return _getQueryResult(response);
  }

  Future<SanityQueryResponse> _executePost(SanityRequest request) async {
    final response = await httpClient.post(
      request.postUri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        ..._requestHeaders,
      },
      body: jsonEncode(request.toPostBody()),
    );

    return _getQueryResult(response);
  }

  //ignore: long-parameter-list
  /// Return the associated image url
  Uri imageUrl(
    final String imageRefId, {
    final int? width,
    final int? height,
    final int? devicePixelRatio,
    final int? quality,
    final String? format,
  }) =>
      urlBuilder.imageUrl(
        imageRefId,
        options: ImageOptions(
          width: width,
          height: height,
          devicePixelRatio: devicePixelRatio,
          quality: quality,
          format: format,
        ),
      );

  /// Return the associated object url
  Uri fileUrl(final String fileRefId) => urlBuilder.fileUrl(fileRefId);

  /// Fetches the associated datasets with this project
  Future<List<SanityDataset>> datasets() async {
    final uri = Uri.parse(
        'https://api.sanity.io/${config.apiVersion}/projects/${config.projectId}/datasets');

    final response = await httpClient.get(uri, headers: _requestHeaders);
    final datasets = (jsonDecode(response.body) as List<dynamic>)
        .map(
          (final json) => SanityDataset.fromJson(json as Map<String, dynamic>),
        )
        .toList(growable: false);

    return datasets;
  }

  SanityQueryResponse _getQueryResult(final http.Response response) {
    switch (response.statusCode) {
      case 200:
        final serverResponse = ServerResponse.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);

        final (age, clientTimeMs, shard) = _extractFromHeaders(response);

        return SanityQueryResponse(
          result: serverResponse.result,
          info: PerformanceInfo(
            age: age ?? -1,
            clientTimeMs: clientTimeMs ?? -1,
            serverTimeMs: serverResponse.ms,
            query: serverResponse.query,
            shard: shard,
          ),
        );
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorizedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          '${response.statusCode}: ${response.body.toString()}',
        );
    }
  }

  (int? age, int? serverTimeMs, String shard) _extractFromHeaders(
      http.Response response) {
    final age = response.headers['x-sanity-age'] ?? '';
    final turnaroundTimeMs =
        (response.headers['server-timing'] ?? '').replaceAll('api;dur=', '');
    final shard = (response.headers['x-sanity-shard'] ?? '');

    return (
      int.tryParse(age, radix: 10),
      int.tryParse(turnaroundTimeMs, radix: 10),
      shard
    );
  }
}

final class _EventFluxHttpClientAdapter implements HttpClientAdapter {
  final http.Client httpClient;

  _EventFluxHttpClientAdapter({required this.httpClient});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      httpClient.send(request);
}
