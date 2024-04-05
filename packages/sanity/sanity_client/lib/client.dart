import 'dart:convert';

import 'package:http/http.dart' as http;

import 'sanity_client.dart';

/// The various perspectives that can be used to fetch data from Sanity
enum Perspective { raw, previewDrafts, published }

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

  SanityConfig({
    required this.projectId,
    required this.dataset,
    required this.token,
    String? apiVersion,
    bool? useCdn,
    Perspective? perspective,
    bool? explainQuery,
  })  : this.useCdn = useCdn ?? true,
        this.apiVersion = apiVersion ?? defaultApiVersion,
        this.perspective = perspective ?? Perspective.raw,
        this.explainQuery = explainQuery ?? false {
    assert(this.token.trim().isNotEmpty, '''
Invalid Token provided. 
Setup an API token, with Viewer access, in the Sanity Management Console.
Without a valid token you will not be able to fetch data from Sanity.''');

    assert(RegExp(r'^v\d{4}-\d{2}-\d{2}$').hasMatch(this.apiVersion),
        'Invalid API version provided. It should follow the format `vYYYY-MM-DD`');
  }
}

/// The client for fetching data from Sanity
class SanityClient {
  /// The configuration for the client
  final SanityConfig config;

  /// The HTTP client to use. Generally not needed to be provided.
  /// It is used for testing purposes
  final http.Client httpClient;

  /// The URL builder to use. When not provided it uses the default Sanity URL builder
  final UrlBuilder urlBuilder;

  final Map<String, String> _requestHeaders;

  SanityClient(
    this.config, {
    final http.Client? httpClient,
    final UrlBuilder? urlBuilder,
  })  : httpClient = httpClient ?? http.Client(),
        urlBuilder = urlBuilder ?? SanityUrlBuilder(config),
        _requestHeaders = {'Authorization': 'Bearer ${config.token}'};

  /// Fetches data from Sanity by running the GROQ Query with the passed in parameters
  Future<SanityQueryResponse> fetch(String query,
      {Map<String, String>? params}) async {
    final uri = queryUrl(query, params: params);
    final response = await httpClient.get(uri, headers: _requestHeaders);

    return _getQueryResult(response);
  }

  /// The URL for the query
  Uri queryUrl(String query, {Map<String, String>? params}) =>
      urlBuilder.queryUrl(query, params: params);

  /// Return the associated image url
  //ignore: long-parameter-list
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
}
