import 'dart:math';

import 'package:sanity_client/sanity_client.dart';

class ImageOptions {
  final int? width;
  final int? height;
  final int? devicePixelRatio;
  final int? quality;
  final String? format;

  ImageOptions(
      {this.width,
      this.height,
      this.devicePixelRatio,
      this.quality,
      this.format});
}

abstract class UrlBuilder<TConfig> {
  final TConfig config;

  UrlBuilder(this.config);

  Uri fileUrl(String fileRefId);

  Uri imageUrl(String imageRefId, {ImageOptions? options});

  Uri queryUrl(String query, {Map<String, String>? params});
}

final class SanityUrlBuilder extends UrlBuilder<SanityConfig> {
  SanityUrlBuilder(super.config);

  @override
  Uri fileUrl(String fileRefId) {
    final parts = fileRefId.split('-');
    assert(parts.length == 3, 'Invalid file reference: $fileRefId');

    final [prefix, id, format] = parts;
    assert(prefix.toLowerCase() == 'file',
        'Invalid file reference: $fileRefId. Must begin with "file"');

    final path = '${config.projectId}/${config.dataset}/$id.$format';

    return Uri.parse('https://cdn.sanity.io/files/$path');
  }

  @override
  Uri imageUrl(String imageRefId, {ImageOptions? options}) {
    _ParsedReference ref;
    try {
      ref = _ParsedReference.from(imageRefId);
    } catch (e) {
      throw InvalidReferenceException(imageRefId);
    }

    final path =
        '${config.projectId}/${config.dataset}/${ref.id}-${ref.width}x${ref.height}.${ref.format}';

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

  @override
  Uri queryUrl(String query, {Map<String, dynamic>? params}) {
    final queryParameters = <String, dynamic>{
      'query': query,
      'explain': config.explainQuery.toString(),
      'perspective': config.perspective.name,
      if (params != null) ...params,
    };

    return Uri(
      scheme: 'https',
      host: '${config.projectId}.${config.useCdn ? 'apicdn' : 'api'}.sanity.io',
      path: '/${config.apiVersion}/data/query/${config.dataset}',
      queryParameters: queryParameters,
    );
  }
}

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
