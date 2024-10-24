import 'package:unsplash_client/unsplash_client.dart';

final class WonderClient {
  final String unsplashAccessKey;
  final String unsplashSecretKey;

  final UnsplashClient _unsplash;

  WonderClient({
    required this.unsplashAccessKey,
    required this.unsplashSecretKey,
  }) : _unsplash = UnsplashClient(
          settings: ClientSettings(
            credentials: AppCredentials(
              accessKey: unsplashAccessKey,
              secretKey: unsplashSecretKey,
            ),
          ),
        );

  Future<List<Photo>> fetchPhotos(String unsplashCollectionId) async {
    final collection = await _unsplash.collections
        .photos(unsplashCollectionId, page: 1, perPage: 25)
        .goAndGet();
    return collection
        .map(
          (photo) => Photo(
            id: photo.id,
            url: photo.urls.regular,
            blurHash: photo.blurHash,
            width: photo.width,
            height: photo.height,
          ),
        )
        .toList();
  }
}

final class Photo {
  final Uri url;
  final String id;
  final String? blurHash;
  final int width;
  final int height;

  Photo({
    required this.id,
    required this.url,
    this.blurHash,
    required this.width,
    required this.height,
  });
}
