import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class NoOpContentProvider extends ContentProvider {
  NoOpContentProvider()
      : super(
          title: 'No Op Content Provider',
          name: 'vyuh.contentProvider.noop',
        );

  @override
  Future<void> dispose() => Future.value();

  @override
  Future<List<T>?> fetchMultiple<T>(
    String query, {
    required FromJsonConverter<T> fromJson,
    Map<String, String>? queryParams,
    bool useCache = true,
  }) =>
      Future.value(null);

  @override
  Future<RouteBase?> fetchRoute({
    String? path,
    String? routeId,
    bool useCache = true,
  }) =>
      Future.value(null);

  @override
  Future<T?> fetchSingle<T>(
    String query, {
    required FromJsonConverter<T> fromJson,
    Map<String, String>? queryParams,
    bool useCache = true,
  }) =>
      Future.value(null);

  @override
  String fieldValue(String key, Map<String, dynamic> json) =>
      throw UnimplementedError();

  @override
  ImageProvider? image(ImageReference imageRef,
          {int? width,
          int? height,
          int? devicePixelRatio,
          int? quality,
          String? format}) =>
      throw UnimplementedError();

  @override
  Future<void> init() => Future.value();

  @override
  String schemaType(Map<String, dynamic> json) => throw UnimplementedError();

  @override
  Future<T?> fetchById<T>(
    String id, {
    required FromJsonConverter<T> fromJson,
    bool useCache = true,
  }) =>
      Future.value(null);

  @override
  Uri? fileUrl(FileReference fileRef) => throw UnimplementedError();
}
