library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:sanity_client/sanity_client.dart';
import 'package:vyuh_cache/vyuh_cache.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_plugin_content_provider_sanity/exception.dart';

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

  factory SanityContentProvider.withConfig(
      {required SanityConfig config, required Duration cacheDuration}) {
    return SanityContentProvider(
      SanityClient(config),
      cacheDuration: cacheDuration,
    );
  }

  @override
  String fieldValue(String key, Map<String, dynamic> json) =>
      json[fieldMap[key]];

  @override
  String schemaType(Map<String, dynamic> json) => fieldValue('type', json);

  @override
  Future<void> init() async {
    _client.setHttpClient(vyuh.network);
  }

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
        .where((x) => x != null)
        .cast<T>()
        .toList(growable: false);
  }

  Future<SanityQueryResponse?> _runQuery(String query,
      [Map<String, String>? queryParams]) async {
    vyuh.log.debug('Running query: $query');
    vyuh.log.debug('with params: $queryParams');

    final url = _client.urlBuilder.queryUrl(query, params: queryParams);
    final response = await _cache.build(url.toString(),
        generateValue: () => _client.fetch(query, params: queryParams));

    if (response != null) {
      vyuh.log.debug(
          'Took server: ${response.info.serverTimeMs}ms, client: ${response.info.clientTimeMs}ms');
    }

    return response;
  }

  static final _routeTypes =
      ["vyuh.route", "vyuh.conditionalRoute"].map((x) => '"$x"').join(', ');

  static get _routeFromPathQuery => '''
*[_type in [$_routeTypes] && path == \$path] | order(_type asc, _updatedAt desc) $_routeContentProjection
  ''';

  static _routeFromIdQuery(bool includeDrafts) => '''
*[_id == \$routeId${includeDrafts ? ' || _id == "drafts." + \$routeId' : ''}] $_routeContentProjection
  ''';

  static _idMatchCondition(String id, {required bool includeDrafts}) =>
      '''*[_id == \$id${includeDrafts ? ' || _id == "drafts." + \$id' : ''}]''';

  static get _routeContentProjection => '''
{
  ...,
  "category": category->,
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
      return fetchSingle<RouteBase>(_routeFromPathQuery,
          fromJson: RouteBase.fromJson, queryParams: {'path': path});
    }

    final includeDrafts =
        _client.config.perspective == Perspective.previewDrafts ||
            _client.config.perspective == Perspective.raw;

    return fetchSingle<RouteBase>(_routeFromIdQuery(includeDrafts),
        fromJson: RouteBase.fromJson, queryParams: {'routeId': '$routeId'});
  }

  @override
  ImageProvider? image(ImageReference imageRef,
      {int? width,
      int? height,
      int? devicePixelRatio,
      int? quality,
      String? format}) {
    final ref = imageRef.asset?.ref;
    if (ref == null) {
      return null;
    }

    final url = _client.imageUrl(
      ref,
      width: width,
      height: height,
      devicePixelRatio: devicePixelRatio,
      quality: quality,
      format: format,
    );

    return CachedNetworkImageProvider(
      url.toString(),
      maxWidth: width,
      maxHeight: height,
      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
    );
  }

  @override
  Uri? fileUrl(FileReference fileRef) {
    return fileRef.asset?.ref != null
        ? _client.fileUrl(fileRef.asset!.ref)
        : null;
  }

  @override
  Future<T?> fetchById<T>(String id, {required FromJsonConverter<T> fromJson}) {
    final condition = _idMatchCondition(id,
        includeDrafts: _client.config.perspective == Perspective.raw);

    return fetchSingle('$condition[0]',
        queryParams: {'id': id}, fromJson: fromJson);
  }
}
