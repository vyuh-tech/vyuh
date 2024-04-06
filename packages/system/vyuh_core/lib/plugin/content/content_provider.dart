import 'package:vyuh_core/vyuh_core.dart';

abstract base class ContentProvider {
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

  Uri? imageUrl(
    final String imageRefId, {
    final int? width,
    final int? height,
    final int? devicePixelRatio,
    final int? quality,
    final String? format,
  });

  Future<T?> fetchSingle<T>(String query,
      {required FromJsonConverter<T> fromJson,
      Map<String, String>? queryParams});

  Future<List<T>?> fetchMultiple<T>(String query,
      {required FromJsonConverter<T> fromJson,
      Map<String, String>? queryParams});

  Future<RouteBase?> fetchRoute({String? path, String? routeId});
}
