part of 'vyuh_plugin_content_provider_sanity.dart';

typedef QueryRecord = ({String query, Map<String, String>? params});

final class _QueryProcessor {
  final SanityClient client;

  _QueryProcessor({required this.client});

  static String idMatchCondition(String id, {required bool includeDrafts}) =>
      '''*[_id == \$id${includeDrafts ? ' || _id == "drafts." + \$id' : ''}]''';

  static final _routeTypes =
      ["vyuh.route", "vyuh.conditionalRoute"].map((x) => '"$x"').join(', ');

  static String get _routeFromPathQuery => '''
*[_type in [$_routeTypes] && path == \$path] | order(_type asc, _updatedAt desc) $_routeContentProjection
  ''';

  static String _routeFromIdQuery(bool includeDrafts) => '''
*[_id == \$routeId${includeDrafts ? ' || _id == "drafts." + \$routeId' : ''}] $_routeContentProjection
  ''';

  static String get _routeContentProjection => '''
{
  ...,
  "category": category->,
  "regions": regions[] {
    "identifier": region->identifier, 
    "title": region->title,
    items,
  },
}[0]
  ''';

  QueryRecord id(String id) {
    final condition = idMatchCondition(id,
        includeDrafts: client.config.perspective == Perspective.raw);

    return (query: '$condition[0]', params: {'id': id});
  }

  QueryRecord route({
    String? path,
    String? routeId,
  }) {
    debugAssertOneOfPathOrRouteId(path, routeId);

    if (path != null) {
      return (query: _routeFromPathQuery, params: {'path': path});
    }

    final includeDrafts = client.config.perspective == Perspective.drafts ||
        client.config.perspective == Perspective.raw;

    return (
      query: _routeFromIdQuery(includeDrafts),
      params: {'routeId': '$routeId'}
    );
  }

  List<T>? processMultiple<T>(
      SanityQueryResponse? response, FromJsonConverter<T> fromJson) {
    if (response != null) {
      _log(
          'Took server: ${response.info.serverTimeMs}ms, client: ${response.info.clientTimeMs}ms');
    }

    if (response == null) {
      return null;
    }

    if (response.result is! List<dynamic>) {
      throw InvalidResultTypeException(
        expectedType: List<dynamic>,
        actualType: response.result.runtimeType,
      );
    }

    final list = response.result as List;

    return list
        .map((json) => fromJson(json as Map<String, dynamic>))
        .where((x) => x != null)
        .cast<T>()
        .toList(growable: false);
  }

  T? processSingle<T>(
      SanityQueryResponse? response, FromJsonConverter<T> fromJson) {
    if (response != null) {
      _log(
          'Took server: ${response.info.serverTimeMs}ms, client: ${response.info.clientTimeMs}ms');
    }

    if (response == null || response.result == null) {
      return null;
    }

    if (response.result is! Map<String, dynamic>) {
      throw InvalidResultTypeException(
        expectedType: Map<String, dynamic>,
        actualType: response.result.runtimeType,
      );
    }

    return fromJson(response.result);
  }
}
