import 'dart:async';
import 'dart:convert';

import 'package:eventflux/eventflux.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'sanity_client.dart';
import 'sanity_request.dart';

part 'live.dart';

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
          if (config.token != null) 'Authorization': 'Bearer ${config.token}',
          'Accept': 'application/json',
        };

  /// Set the HTTP client to use for fetching data
  void setHttpClient(http.Client client) {
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
          syncTags: serverResponse.syncTags,
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
