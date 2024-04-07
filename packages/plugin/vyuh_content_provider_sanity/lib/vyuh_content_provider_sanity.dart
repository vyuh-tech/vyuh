library vyuh_plugin_content_sanity;

import 'package:sanity_client/sanity_client.dart';
import 'package:vyuh_cache/vyuh_cache.dart';
import 'package:vyuh_content_provider_sanity/exception.dart';
import 'package:vyuh_core/vyuh_core.dart';

identity(Map<String, dynamic> json) => json;

final Map<String, String> fieldMap = {
  FieldName.id.name: '_id',
  FieldName.type.name: '_type',
  FieldName.key.name: '_key',
  FieldName.createdAt.name: '_createdAt',
  FieldName.updatedAt.name: '_updatedAt',
  FieldName.ref.name: '_ref',
};

final class SanityContentProvider extends ContentProvider {
  final SanityClient _client;
  final Duration cacheDuration;
  final Cache<SanityQueryResponse> _cache;

  SanityContentProvider(SanityClient client,
      {this.cacheDuration = const Duration(minutes: 5)})
      : _client = client,
        _cache = Cache(
            CacheConfig(storage: MemoryCacheStorage(), ttl: cacheDuration)),
        super(
            name: 'vyuh.content.provider.sanity',
            title: 'Sanity Content Provider');

  @override
  String fieldValue(String key, Map<String, dynamic> json) =>
      json[fieldMap[key]];

  @override
  String schemaType(Map<String, dynamic> json) => fieldValue('type', json);

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<T?> fetchSingle<T>(String query,
      {required FromJsonConverter<T> fromJson,
      Map<String, String>? queryParams}) async {
    final response = await _runQuery(query, queryParams);
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

  @override
  Future<List<T>?> fetchMultiple<T>(String query,
      {required FromJsonConverter<T> fromJson,
      Map<String, String>? queryParams}) async {
    final response = await _runQuery(query, queryParams);
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
        .toList(growable: false);
  }

  Future<SanityQueryResponse?> _runQuery(String query,
      [Map<String, String>? queryParams]) async {
    vyuh.log?.d('Running query: $query');
    vyuh.log?.d('with params: $queryParams');

    final url = _client.queryUrl(query, params: queryParams);
    final response = await _cache.build(url.toString(),
        generateValue: () => _client.fetch(query, params: queryParams));

    if (response != null) {
      vyuh.log?.d(
          'Took server: ${response.info.serverTimeMs}ms, client: ${response.info.clientTimeMs}ms');
    }

    return response;
  }

  static final _routeTypes =
      ["vyuh.route", "vyuh.conditionalRoute"].map((x) => '"$x"').join(', ');

  static get _routeFromPathQuery => '''
*[_type in [$_routeTypes] && path == \$path] | order(_type asc, _updatedAt desc) $_projection
  ''';

  static _routeFromIdQuery(bool includeDrafts) => '''
*[_id == \$routeId${includeDrafts ? ' || _id == "drafts." + \$routeId' : ''}] $_projection
  ''';

  static get _projection => '''
{
  ...,
  "category": category->title,
  "regions": regions[] {
    "identifier": region->identifier, 
    "title": region->title,
    "items": items
  },
}[0]
  ''';

  @override
  Future<RouteBase?> fetchRoute({String? path, String? routeId}) async {
    debugAssertOneOfPathOrRouteId(path, routeId);

    if (path != null) {
      // We have to escape the $ with \$ in order to include it as a character in the string.
      // Since it is a string, the value has to be wrapped in quotes
      return fetchSingle<RouteBase>(_routeFromPathQuery,
          fromJson: RouteBase.fromJson, queryParams: {'\$path': '"$path"'});
    }

    final includeDrafts =
        _client.config.perspective == Perspective.previewDrafts ||
            _client.config.perspective == Perspective.raw;

    return fetchSingle<RouteBase>(_routeFromIdQuery(includeDrafts),
        fromJson: RouteBase.fromJson, queryParams: {'\$routeId': '"$routeId"'});
  }

  @override
  Uri? imageUrl(String imageRefId,
          {int? width,
          int? height,
          int? devicePixelRatio,
          int? quality,
          String? format}) =>
      _client.imageUrl(
        imageRefId,
        width: width,
        height: height,
        devicePixelRatio: devicePixelRatio,
        quality: quality,
        format: format,
      );
}
