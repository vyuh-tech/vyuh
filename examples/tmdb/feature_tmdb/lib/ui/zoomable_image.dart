import 'package:cached_network_image/cached_network_image.dart';
import 'package:design_system/design_system.dart' hide BorderRadius;
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:vyuh_core/vyuh_core.dart';

class ZoomableImage extends StatelessWidget {
  const ZoomableImage({
    super.key,
    required this.child,
    this.imageUrl,
    this.fit = BoxFit.fill,
    required this.title,
  });

  final Widget child;
  final String? imageUrl;
  final BoxFit fit;
  final String title;

  @override
  Widget build(BuildContext context) {
    final tag = UniqueKey();
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) {
            return InteractiveFullScreenViewer(
              title: title,
              tag: tag,
              imageUrl: imageUrl!,
              onClose: () {},
            );
          },
        ),
      ),
      child: child,
    );
  }
}

class InteractiveFullScreenViewer extends StatelessWidget {
  final void Function() onClose;

  const InteractiveFullScreenViewer({
    super.key,
    required this.tag,
    required this.onClose,
    required this.title,
    this.imageUrl,
  });

  final Object tag;
  final String title;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    if (imageUrl != null) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          titleSpacing: 10,
          backgroundColor: theme.colorScheme.surface,
          centerTitle: false,
          leading: Container(
            margin: EdgeInsets.only(left: theme.spacing.s32),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
                onClose();
              },
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.tmdbTheme.displaySmall),
              Text(
                'Glimpses enlarged',
                style: theme.tmdbTheme.bodySmall,
              ),
            ],
          ),
        ),
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(
            height: size.height,
            width: size.width,
          ),
          child: PhotoViewGallery.builder(
            itemCount: 1,
            builder: (_, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(
                  imageUrl!,
                ),
                minScale: PhotoViewComputedScale.covered,
                maxScale: PhotoViewComputedScale.covered,
                heroAttributes: PhotoViewHeroAttributes(tag: tag),
              );
            },
            backgroundDecoration: BoxDecoration(
              color: theme.colorScheme.surface,
            ),
            pageController: PageController(),
            enableRotation: true,
            scrollPhysics: const BouncingScrollPhysics(),
            loadingBuilder: (context, event) =>
                vyuh.widgetBuilder.routeLoader(context),
          ),
        ),
      );
    } else {
      return ClipRect(
        child: vyuh.widgetBuilder.imagePlaceholder(
          context,
          width: theme.sizing.widthFull(size.width),
          height: theme.sizing.widthFull(size.height),
        ),
      );
    }
  }
}
