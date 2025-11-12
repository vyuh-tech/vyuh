library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:sanity_client/sanity_client.dart';
import 'package:vyuh_cache/vyuh_cache.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_plugin_content_provider_sanity/exception.dart';

part 'live_provider.dart';
part 'processor.dart';

Map<String, dynamic> identity(Map<String, dynamic> json) => json;

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
  late final _QueryProcessor _processor;

  SanityContentProvider(
    SanityClient client, {
    this.cacheDuration = const Duration(minutes: 5),
  })  : _client = client,
        _cache = Cache(
            CacheConfig(storage: MemoryCacheStorage(), ttl: cacheDuration)),
        super(
          name: 'vyuh.content.provider.sanity',
          title: 'Sanity Content Provider',
          live: _SanityLiveContentProvider(),
        ) {
    _processor = _QueryProcessor(client: _client);

    final liveProvider = live as _SanityLiveContentProvider;
    liveProvider.setProcessor(_processor);
  }

  factory SanityContentProvider.withConfig({
    required SanityConfig config,
    required Duration cacheDuration,
  }) {
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
    _client.setHttpClient(VyuhBinding.instance.network);
    await live.init();
  }

  @override
  Future<void> dispose() async {
    await live.dispose();
  }

  @override
  Future<T?> fetchById<T>(
    String id, {
    required FromJsonConverter<T> fromJson,
    bool useCache = true,
  }) {
    final record = _processor.id(id);

    return fetchSingle(
      record.query,
      queryParams: record.params,
      fromJson: fromJson,
    );
  }

  @override
  Future<T?> fetchSingle<T>(
    String query, {
    required FromJsonConverter<T> fromJson,
    Map<String, String>? queryParams,
    bool useCache = true,
  }) async {
    final response = await _runQuery(query, queryParams, useCache);
    return _processor.processSingle(response, fromJson);
  }

  @override
  Future<List<T>?> fetchMultiple<T>(
    String query, {
    required FromJsonConverter<T> fromJson,
    Map<String, String>? queryParams,
    bool useCache = true,
  }) async {
    final response = await _runQuery(query, queryParams, useCache);
    return _processor.processMultiple(response, fromJson);
  }

  @override
  Future<RouteBase?> fetchRoute({
    String? path,
    String? routeId,
    bool useCache = true,
  }) async {
    final record = _processor.route(path: path, routeId: routeId);

    return fetchSingle<RouteBase>(
      record.query,
      queryParams: record.params,
      fromJson: RouteBase.fromJson,
    );
  }

  Future<SanityQueryResponse?> _runQuery(
    String query, [
    Map<String, String>? queryParams,
    bool useCache = true,
  ]) async {
    _log('Running query: $query');
    _log('with params: $queryParams');

    final url = _client.urlBuilder.queryUrl(query, params: queryParams);
    final response = await (useCache
        ? _cache.build(url.toString(),
            generateValue: () => _client.fetch(query, params: queryParams))
        : _client.fetch(query, params: queryParams));

    return response;
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
}

void _log(String message) {
  VyuhBinding.instance.log.debug(message);
}
