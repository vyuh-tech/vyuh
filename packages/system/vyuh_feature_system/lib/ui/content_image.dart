import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

class ContentImage extends StatelessWidget {
  final String? url;
  final ImageReference? ref;
  final double? width;
  final double? height;

  final BoxFit fit;
  final String? format;

  static const int nearestSize = 10;

  final Color? color;
  final BlendMode? colorBlendMode;
  final AlignmentGeometry alignment;

  const ContentImage({
    super.key,
    this.url,
    this.width,
    this.height,
    this.ref,
    this.fit = BoxFit.cover,
    this.format,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(final BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context).toInt();

    return LayoutBuilder(
      builder: (final BuildContext context, final BoxConstraints constraints) {
        var roundedWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth.roundedTo(nearestSize)
            : constraints.minWidth > 0
                ? constraints.minWidth.roundedTo(nearestSize)
                : null;
        final roundedHeight = (roundedWidth == null)
            ? null
            : (constraints.maxHeight.isFinite
                ? constraints.maxHeight.roundedTo(nearestSize)
                : (constraints.minHeight > 0
                    ? constraints.minHeight.roundedTo(nearestSize)
                    : null));

        roundedWidth = (roundedWidth == null && roundedHeight == null)
            ? MediaQuery.sizeOf(context).width.roundedTo(nearestSize)
            : roundedWidth;

        final imageWidth = width ?? roundedWidth?.toDouble();
        final imageHeight = height ?? roundedHeight?.toDouble();

        final provider = (ref != null)
            ? vyuh.content.provider.image(
                ref!,
                width: roundedWidth,
                height: roundedHeight,
                devicePixelRatio: dpr,
                quality: dpr > 1 ? 90 : 50,
                format: format,
              )
            : url != null && url!.isNotEmpty
                ? CachedNetworkImageProvider(
                    url!,
                    maxHeight: imageHeight?.toInt(),
                    maxWidth: imageWidth?.toInt(),
                  )
                : null;

        if (provider == null) {
          return ClipRect(
            child: vyuh.widgetBuilder.imagePlaceholder(
              width: imageWidth,
              height: imageHeight,
            ),
          );
        } else {
          return Image(
            image: provider,
            errorBuilder: (final context, final __, final ___) =>
                vyuh.widgetBuilder.imagePlaceholder(
              width: imageWidth,
              height: imageHeight,
            ),
            width: imageWidth,
            height: imageHeight,
            fit: fit,
            alignment: alignment,
            color: color,
            colorBlendMode: colorBlendMode,
          );
        }
      },
    );
  }
}

extension on double {
  int roundedTo(final int multiple) {
    final value = toInt();
    final remainder = value % multiple;

    return remainder == 0 ? value : (value - remainder);
  }
}
