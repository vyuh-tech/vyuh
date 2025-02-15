import 'dart:math';

import 'package:sanity_client/sanity_client.dart';

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
  Uri queryUrl(String query, {Map<String, String>? params, bool live = false});
}

/// A URL builder implementation for Sanity.
///
/// Supports building URLs for files, images, and queries.
final class SanityUrlBuilder extends UrlBuilder<SanityConfig> {
  /// Creates a new Sanity URL builder with the provided configuration.
  SanityUrlBuilder(super.config);

  @override
  Uri fileUrl(String fileRefId) {
    final fileName = SanityUrlBuilder.fileName(fileRefId);

    final path = '${config.projectId}/${config.dataset}/$fileName';

    return Uri.parse('https://cdn.sanity.io/files/$path');
  }

  /// Generates the file name from the file reference ID.
  static String fileName(String fileRefId) {
    final parts = fileRefId.split('-');
    assert(parts.length == 3, 'Invalid file reference: $fileRefId');

    final [prefix, id, format] = parts;
    assert(prefix.toLowerCase() == 'file',
        'Invalid file reference: $fileRefId. Must begin with "file"');

    return '$id.$format';
  }

  @override
  Uri imageUrl(String imageRefId, {ImageOptions? options}) {
    _assertValidImageOptions(options);

    final fileName = SanityUrlBuilder.imageFileName(imageRefId);

    final path = '${config.projectId}/${config.dataset}/$fileName';

    final params = options == null
        ? ''
        : [
            if (options.width != null) 'w=${options.width}',
            if (options.height != null) 'h=${options.height}',
            if (options.devicePixelRatio != null)
              'dpr=${options.devicePixelRatio}',
            if (options.format != null) 'fm=${options.format}',
            if (options.quality != null)
              'q=${max(0, min(options.quality!, 100))}',
          ].join('&');

    final query = params.isEmpty ? '' : '?$params';
    return Uri.parse('https://cdn.sanity.io/images/$path$query');
  }

  /// Generates the image file name from the image reference ID.
  static String imageFileName(String imageRefId) {
    _ParsedReference ref;
    try {
      ref = _ParsedReference.from(imageRefId);
    } catch (e) {
      throw InvalidReferenceException(imageRefId);
    }

    return '${ref.id}-${ref.width}x${ref.height}.${ref.format}';
  }

  @override
  Uri queryUrl(String query,
      {Map<String, dynamic>? params, bool live = false}) {
    final queryParameters = <String, dynamic>{
      'query': query,
      'explain': config.explainQuery.toString(),
      'perspective': config.perspective.name,
      if (params != null)
        ...params.map((key, value) => MapEntry('\$$key', '"$value"')),
    };

    final host =
        '${config.projectId}.${config.useCdn && !live ? 'apicdn' : 'api'}.sanity.io';
    final path =
        '/${live ? 'vX' : config.apiVersion}/data/${live ? 'live/events' : 'query'}/${config.dataset}';

    return Uri(
      scheme: 'https',
      host: host,
      path: path,
      queryParameters: queryParameters,
    );
  }

  void _assertValidImageOptions(ImageOptions? options) {
    if (options == null) {
      return;
    }

    final width = options.width;
    final height = options.height;

    // Assert positive width and height
    if (width != null && width <= 0) {
      throw ArgumentError("Width must be a number greater than zero");
    }

    if (height != null && height <= 0) {
      throw ArgumentError("Height must be a number greater than zero");
    }

    // Assert positive devicePixelRatio between 1 and 5
    final dpr = options.devicePixelRatio;
    if (dpr != null && (dpr < 1 || dpr > 5)) {
      throw ArgumentError("Device pixel ratio must be between 1 and 5");
    }

    // Assert quality between 0 and 100
    final quality = options.quality;
    if (quality != null && (quality < 0 || quality > 100)) {
      throw ArgumentError("Quality must be between 0 and 100");
    }
  }
}

/// Internal class to parse image reference IDs.
class _ParsedReference {
  final String id;
  final int width;
  final int height;
  final String format;

  // example refId: image-Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000-jpg
  factory _ParsedReference.from(final String refId) {
    final parts = refId.split('-');
    assert(parts.length == 4, 'Invalid image reference: $refId');

    final [prefix, id, dimensions, format] = parts;
    assert(prefix.toLowerCase() == 'image',
        'Invalid image reference: $refId. Must begin with "image"');

    final [w, h] = dimensions.split('x');

    final width = int.parse(w, radix: 10);
    final height = int.parse(h, radix: 10);

    return _ParsedReference._(id, width, height, format);
  }

  _ParsedReference._(this.id, this.width, this.height, this.format);
}
