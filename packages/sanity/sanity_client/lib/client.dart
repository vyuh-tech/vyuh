import 'dart:convert';

import 'package:http/http.dart' as http;

import 'sanity_client.dart';

enum Perspective { raw, previewDrafts, published }

final class SanityConfig {
  final String dataset;
  final String projectId;
  final String token;
  final bool useCdn;
  final String apiVersion;
  final Perspective perspective;
  final bool explainQuery;

  static const defaultApiVersion = 'v2021-10-21';

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
    assert(this.token.trim().isNotEmpty, 'Invalid Token provided');
  }
}

class SanityClient {
  final SanityConfig config;
  final http.Client httpClient;
  final UrlBuilder urlBuilder;

  final Map<String, String> _requestHeaders;

  SanityClient(
    this.config, {
    final http.Client? httpClient,
    final UrlBuilder? urlBuilder,
  })  : httpClient = httpClient ?? http.Client(),
        urlBuilder = urlBuilder ?? SanityUrlBuilder(config),
        _requestHeaders = {'Authorization': 'Bearer ${config.token}'};

  Future<SanityQueryResponse> fetch(Uri uri) async {
    final response = await httpClient.get(uri, headers: _requestHeaders);

    return _getQueryResult(response);
  }

  Uri queryUrl(String query, {Map<String, String>? params}) =>
      urlBuilder.queryUrl(query, params: params);

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
