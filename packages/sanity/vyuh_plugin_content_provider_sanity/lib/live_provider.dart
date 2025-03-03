part of 'vyuh_plugin_content_provider_sanity.dart';

class _SanityLiveContentProvider extends LiveContentProvider {
  late final _QueryProcessor processor;

  _SanityLiveContentProvider() : super(title: 'Sanity Live Content Provider');

  void setProcessor(_QueryProcessor processor) {
    this.processor = processor;
  }

  @override
  Stream<T?> fetchById<T>(String id,
      {required FromJsonConverter<T> fromJson, bool includeDrafts = false}) {
    final record = processor.id(id);
    return processor.client
        .fetchLive(record.query,
            params: record.params, includeDrafts: includeDrafts)
        .map((response) => processor.processSingle(response, fromJson));
  }

  @override
  Stream<T?> fetchSingle<T>(String query,
      {required FromJsonConverter<T> fromJson,
      Map<String, String>? queryParams,
      bool includeDrafts = false}) {
    return processor.client
        .fetchLive(query, params: queryParams, includeDrafts: includeDrafts)
        .map((response) => processor.processSingle(response, fromJson));
  }

  @override
  Stream<List<T>?> fetchMultiple<T>(String query,
      {required FromJsonConverter<T> fromJson,
      Map<String, String>? queryParams,
      bool includeDrafts = false}) {
    return processor.client
        .fetchLive(query, params: queryParams, includeDrafts: includeDrafts)
        .map((response) => processor.processMultiple(response, fromJson));
  }

  @override
  Stream<RouteBase?> fetchRoute({
    String? path,
    String? routeId,
    bool includeDrafts = false,
  }) {
    final record = processor.route(path: path, routeId: routeId);

    return processor.client
        .fetchLive(
          record.query,
          params: record.params,
          includeDrafts: includeDrafts,
        )
        .map((response) =>
            processor.processSingle(response, RouteBase.fromJson));
  }

  @override
  Future<void> dispose() => Future.value();

  @override
  Future<void> init() => Future.value();
}
