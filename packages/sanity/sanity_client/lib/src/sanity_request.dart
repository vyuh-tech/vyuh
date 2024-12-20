import 'dart:convert';

import '../sanity_client.dart';

class SanityRequest {
  static const int _maxGetQuerySize = 11 * 1024; // 11kB limit

  final UrlBuilder urlBuilder;
  final String query;
  final Map<String, String>? params;

  SanityRequest({
    required this.urlBuilder,
    required this.query,
    this.params,
  });

  /// Queries longer than 11kB can’t be submitted using the GET method,
  /// so they must be POSTed. See https://www.sanity.io/docs/http-query
  bool get requiresPost {
    final uri = getUri;
    final bytes = utf8.encode(uri.toString());
    return bytes.lengthInBytes > _maxGetQuerySize;
  }

  Uri get getUri => urlBuilder.queryUrl(query, params: params);

  Uri get postUri {
    final getUri = urlBuilder.queryUrl('', params: const {});

    return getUri.replace(
      queryParameters: <String, dynamic>{
        'explain': getUri.queryParameters['explain'],
        'perspective': getUri.queryParameters['perspective'],
      },
    );
  }

  /// Strips the $-prefixes when submitting as json params via POST
  Map<String, dynamic> toPostBody() {
    return {
      'query': query,
      'params': _stripDollarPrefixes(params),
    };
  }

  Map<String, String>? _stripDollarPrefixes(Map<String, String>? params) {
    if (params == null) return null;

    return params.map((key, value) {
      final newKey = key.startsWith('\$') ? key.substring(1) : key;
      return MapEntry(newKey, value);
    });
  }
}
