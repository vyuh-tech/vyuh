import 'package:unsplash_client/unsplash_client.dart';

final class UnsplashStore {
  final UnsplashClient _client;

  UnsplashStore({required String accessKey, required String secretKey})
      : _client = UnsplashClient(
          settings: ClientSettings(
            credentials: AppCredentials(
              accessKey: accessKey,
              secretKey: secretKey,
            ),
          ),
        );

  Future<List<Photo>> fetchFeaturedPhotos({required int count}) =>
      _client.photos
          .random(
            count: count,
            featured: true,
            orientation: PhotoOrientation.landscape,
          )
          .goAndGet();

  Future<List<Photo>> fetchPhotos(
          {required int count, PhotoOrder orderBy = PhotoOrder.latest}) =>
      _client.photos.list(perPage: count, orderBy: orderBy).goAndGet();

  Future<Photo> fetchPhoto({required String id}) =>
      _client.photos.get(id).goAndGet();

  Future<List<Topic>> fetchTopics({required int count}) => _client.topics
      .list(perPage: count, orderBy: TopicOrder.featured)
      .goAndGet();

  Future<List<Photo>> fetchTopic({required String id}) =>
      _client.topics.photos(id, perPage: 10).goAndGet();

  Future<List<Collection>> fetchCollections({required int count}) =>
      _client.collections.list(perPage: 10).goAndGet();

  Future<List<Photo>> fetchCollection({required String id}) =>
      _client.collections.photos(id, perPage: 10).goAndGet();

  Future<List<Photo>> searchPhotos(
      {required String query, int maxResults = 20}) async {
    final results = await _client.search
        .photos(query, perPage: maxResults, orderBy: PhotoOrder.latest)
        .goAndGet();
    return results.results;
  }
}
