/// Options to customize the image URL.
///
/// This class is used to customize the image URL when fetching images from Sanity.
/// You can provide various parameter such as [width], [height], [quality], [devicePixelRatio], [format],
/// which will then be used to generate the image URL.
class ImageOptions {
  /// The width of the image in pixels.
  final int? width;

  /// The height of the image in pixels.
  final int? height;

  /// The device pixel ratio of the image.
  final int? devicePixelRatio;

  /// The quality of the image, expressed as value between 0-100
  final int? quality;

  /// The format of the image. Can be either `jpg`, `png`, `webp`, or `auto`.
  final String? format;

  /// Creates a new image options object with the provided parameters. This
  /// handles width, height, device pixel ratio, quality, and format.
  ImageOptions({
    this.width,
    this.height,
    this.devicePixelRatio,
    this.quality,
    this.format,
  });
}

/// Configuration for live queries
class LiveConfig {
  /// Whether to include drafts in the query
  final bool includeDrafts;

  /// Creates a new LiveConfig object with the provided includeDrafts parameter.
  LiveConfig({this.includeDrafts = false});

  /// Creates a new LiveConfig object with the includeDrafts parameter set to true.
  LiveConfig.withDrafts() : includeDrafts = true;
}

/// Provides the main interface for building URLs for Sanity assets.
///
/// This class is used to build URLs for Sanity assets such as files, images, and queries.
abstract class UrlBuilder<TConfig> {
  /// The configuration object for the client, which is specific to the URL builder implementation.
  final TConfig config;

  /// Creates a new URL builder with the provided configuration.
  UrlBuilder(this.config);

  /// Builds a URL for a file asset.
  Uri fileUrl(String fileRefId);

  /// Builds a URL for an image asset.
  Uri imageUrl(String imageRefId, {ImageOptions? options});

  /// Builds a URL for a GROQ query.
  Uri queryUrl(String query, {Map<String, String>? params, LiveConfig? live});
}
