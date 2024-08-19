import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

abstract class ContentProvider {
  final String name;
  final String title;

  ContentProvider({
    required this.name,
    required this.title,
  });

  String fieldValue(String key, Map<String, dynamic> json);

  String schemaType(Map<String, dynamic> json);

  Future<void> init();
  Future<void> dispose();

  ImageProvider? image(
    final ImageReference imageRef, {
    final int? width,
    final int? height,
    final int? devicePixelRatio,
    final int? quality,
    final String? format,
  });

  Uri? fileUrl(
    final FileReference fileRef,
  );

  Future<T?> fetchById<T>(String id, {required FromJsonConverter<T> fromJson});

  Future<T?> fetchSingle<T>(String query,
      {required FromJsonConverter<T> fromJson,
      Map<String, String>? queryParams});

  Future<List<T>?> fetchMultiple<T>(String query,
      {required FromJsonConverter<T> fromJson,
      Map<String, String>? queryParams});

  Future<RouteBase?> fetchRoute({String? path, String? routeId});
}
