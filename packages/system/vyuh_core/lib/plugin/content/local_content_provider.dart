import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

const fieldKeyMap = {
  'key': 'key',
  'id': 'id',
  'schemaType': 'schemaType',
};

final class LocalContentProvider extends ContentProvider {
  LocalContentProvider()
      : super(
            name: 'vyuh.contentProvider.local',
            title: 'Local Content Provider');

  @override
  String schemaType(Map<String, dynamic> json) {
    return json['schemaType'] ?? '';
  }

  @override
  String fieldValue(String key, Map<String, dynamic> json) {
    return json[fieldKeyMap[key] ?? key];
  }

  // All the fetch methods will be unimplemented because we are trying to fetch content locally.
  // Right now, this is a placeholder, and once we get more clarity about what
  // `local_content_provider` even means, we will supplant these methods with something more meaningful.
  @override
  Future<T?> fetchById<T>(String id,
          {required FromJsonConverter<T> fromJson, bool useCache = true}) =>
      throw UnimplementedError();

  @override
  Future<List<T>?> fetchMultiple<T>(String query,
          {required FromJsonConverter<T> fromJson,
          Map<String, String>? queryParams,
          bool useCache = true}) =>
      throw UnimplementedError();

  @override
  Future<RouteBase?> fetchRoute(
          {String? path, String? routeId, bool useCache = true}) =>
      throw UnimplementedError();

  @override
  Future<T?> fetchSingle<T>(String query,
          {required FromJsonConverter<T> fromJson,
          Map<String, String>? queryParams,
          bool useCache = true}) =>
      throw UnimplementedError();

  @override
  Uri? fileUrl(FileReference fileRef) => throw UnimplementedError();

  @override
  ImageProvider<Object>? image(ImageReference imageRef,
          {int? width,
          int? height,
          int? devicePixelRatio,
          int? quality,
          String? format}) =>
      throw UnimplementedError();

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}
}
