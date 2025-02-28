import 'package:vyuh_core/vyuh_core.dart';

/// An interface for plugins that provide live content.
///
/// Live content providers are used in conjunction with the content system
/// to provide content that is fetched and updated in real-time.
/// It supports all modes of fetching content: by ID, by query, or by route.
abstract class LiveContentProvider {
  /// The title of the live content provider.
  final String title;

  const LiveContentProvider({required this.title});

  Future<void> init();
  Future<void> dispose();

  /// Fetches content by ID.
  Stream<T?> fetchById<T>(
    String id, {
    required FromJsonConverter<T> fromJson,
    bool includeDrafts = false,
  });

  /// Fetches content by query, returning a single item.
  Stream<T?> fetchSingle<T>(
    String query, {
    required FromJsonConverter<T> fromJson,
    Map<String, String>? queryParams,
    bool includeDrafts = false,
  });

  /// Fetches content by query, returning a list of items.
  Stream<List<T>?> fetchMultiple<T>(
    String query, {
    required FromJsonConverter<T> fromJson,
    Map<String, String>? queryParams,
    bool includeDrafts = false,
  });

  /// Fetches content by route.
  Stream<RouteBase?> fetchRoute({
    String? path,
    String? routeId,
    bool includeDrafts = false,
  });
}

/// A no-op implementation of [LiveContentProvider].
/// Is used internally to ensure the Developer is using it correctly by giving proper errors
/// and hints
final class NoOpLiveContentProvider extends LiveContentProvider {
  const NoOpLiveContentProvider() : super(title: 'No Op Live Provider');

  @override
  Stream<T?> fetchById<T>(String id,
          {required FromJsonConverter<T> fromJson,
          bool includeDrafts = false}) =>
      _error('fetchById');

  @override
  Stream<T?> fetchSingle<T>(String query,
          {required FromJsonConverter<T> fromJson,
          Map<String, String>? queryParams,
          bool includeDrafts = false}) =>
      _error('fetchSingle');

  @override
  Stream<List<T>?> fetchMultiple<T>(String query,
          {required FromJsonConverter<T> fromJson,
          Map<String, String>? queryParams,
          bool includeDrafts = false}) =>
      _error('fetchMultiple');

  @override
  Stream<RouteBase?> fetchRoute(
          {String? path, String? routeId, bool includeDrafts = false}) =>
      _error('fetchRoute');

  @override
  Future<void> dispose() async {}

  @override
  Future<void> init() async {}

  _error(String methodName) {
    throw UnimplementedError('''
You are using the $methodName from NoOpLiveContentProvider, which is not implemented.
Derive from $LiveContentProvider for a real implementation.''');
  }
}
