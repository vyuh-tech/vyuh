import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

abstract class ContentProvider {
  final String name;
  final String title;
  final LiveContentProvider live;

  ContentProvider({
    required this.name,
    required this.title,
    this.live = const NoOpLiveContentProvider(),
  });

  @nonVirtual
  bool get supportsLive => live is! NoOpLiveContentProvider;

  String fieldValue(String key, Map<String, dynamic> json);

  String schemaType(Map<String, dynamic> json);

  Future<void> init();
  Future<void> dispose();

  ImageProvider? image(
    ImageReference imageRef, {
    int? width,
    int? height,
    int? devicePixelRatio,
    int? quality,
    String? format,
  });

  Uri? fileUrl(
    FileReference fileRef,
  );

  Future<T?> fetchById<T>(
    String id, {
    required FromJsonConverter<T> fromJson,
    bool useCache = true,
  });

  Future<T?> fetchSingle<T>(
    String query, {
    required FromJsonConverter<T> fromJson,
    Map<String, String>? queryParams,
    bool useCache = true,
  });

  Future<List<T>?> fetchMultiple<T>(
    String query, {
    required FromJsonConverter<T> fromJson,
    Map<String, String>? queryParams,
    bool useCache = true,
  });

  Future<RouteBase?> fetchRoute({
    String? path,
    String? routeId,
    bool useCache = true,
  });
}
