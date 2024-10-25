import 'package:feature_unsplash/unsplash_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:vyuh_core/vyuh_core.dart';

class PhotoDetail extends StatelessWidget {
  final String id;
  const PhotoDetail({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final store = vyuh.di.get<UnsplashStore>();

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Hero(
          tag: id,
          child: FutureBuilder(
            future: store.fetchPhoto(id: id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return vyuh.widgetBuilder.contentLoader(context);
              }

              if (snapshot.hasError || snapshot.hasData == false) {
                return vyuh.widgetBuilder.errorView(
                  context,
                  title: 'Failed to load photo',
                  error: snapshot.error,
                );
              }

              final photo = snapshot.data as Photo;
              final theme = Theme.of(context);

              return Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: PhotoView(
                        minScale: 0.1,
                        maxScale: 1.0,
                        strictScale: true,
                        backgroundDecoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainer),
                        enablePanAlways: true,
                        gestureDetectorBehavior: HitTestBehavior.opaque,
                        basePosition: Alignment.topCenter,
                        imageProvider: NetworkImage(
                          photo.urls.full.toString(),
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: _PhotoInfo(photo: photo),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PhotoInfo extends StatelessWidget {
  final Photo photo;

  const _PhotoInfo({
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: theme.colorScheme.inverseSurface.withOpacity(0.25),
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (photo.description != null)
              Text(
                photo.description!,
                style: theme.textTheme.titleMedium,
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Color(int.parse(
                      'FF${photo.color.toUpperCase().replaceAll('#', '')}',
                      radix: 16)),
                  width: 64,
                  height: 64,
                ),
                Chip(
                  avatar: CircleAvatar(
                      foregroundImage: NetworkImage(
                          photo.user.profileImage.small.toString())),
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(photo.user.name, style: theme.textTheme.labelSmall),
                      if (photo.user.twitterUsername != null)
                        Text('@${photo.user.twitterUsername!}',
                            style: theme.textTheme.labelSmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.favorite),
                  label: Text(photo.likes.toString()),
                ),
                Chip(
                  avatar: const Icon(Icons.download),
                  label: Text(photo.downloads?.toString() ?? ''),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(DateFormat.yMMMMd().format(photo.createdAt),
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Text('Tags', style: theme.textTheme.titleSmall),
            if (photo.tags != null && photo.tags!.isNotEmpty)
              SizedBox(
                height: 50,
                child: ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemCount: photo.tags!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) =>
                      Chip(label: Text(photo.tags![index].title)),
                ),
              ),
            const SizedBox(height: 16),
            if (photo.exif != null) ExifView(exif: photo.exif!)
          ],
        ),
      ),
    );
  }
}

class ExifView extends StatelessWidget {
  final Exif exif;
  const ExifView({super.key, required this.exif});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceDim,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 32,
        runSpacing: 32,
        children: [
          _ExifStat(label: 'Make', value: exif.make),
          _ExifStat(label: 'Model', value: exif.model),
          _ExifStat(label: 'ISO', value: exif.iso?.toString()),
          _ExifStat(label: 'Focal Length', value: exif.focalLength),
          _ExifStat(label: 'Aperture', value: exif.aperture),
          _ExifStat(label: 'Exposure', value: exif.exposureTime),
        ],
      ),
    );
  }
}

class _ExifStat extends StatelessWidget {
  final String label;
  final String? value;

  const _ExifStat({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: theme.textTheme.labelSmall
                ?.apply(color: theme.colorScheme.onSurface)),
        Text(value ?? '---',
            style: theme.textTheme.titleMedium
                ?.apply(color: theme.colorScheme.onSurface)),
      ],
    );
  }
}
