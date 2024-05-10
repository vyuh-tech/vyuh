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

  ContentImage({
    super.key,
    this.url,
    this.width,
    this.height,
    this.ref,
    this.fit = BoxFit.cover,
    this.format,
  }) {
    assert((url != null && ref == null) || (url == null && ref != null),
        'One of url or ref must be specified.');
  }

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

        final provider = (ref != null)
            ? vyuh.content.provider.image(
                ref!,
                width: roundedWidth,
                height: roundedHeight,
                devicePixelRatio: dpr,
                quality: dpr > 1 ? 90 : 50,
                format: format,
              )
            : NetworkImage(url ?? '');

        return provider == null
            ? vyuh.widgetBuilder.imagePlaceholder(
                width: roundedWidth?.toDouble(),
                height: roundedHeight?.toDouble())
            : Image(
                image: provider,
                errorBuilder: (final context, final __, final ___) =>
                    vyuh.widgetBuilder.imagePlaceholder(
                        width: roundedWidth?.toDouble(),
                        height: roundedHeight?.toDouble()),
                width: roundedWidth?.toDouble() ?? width,
                height: roundedHeight?.toDouble() ?? height,
                fit: fit,
              );
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
