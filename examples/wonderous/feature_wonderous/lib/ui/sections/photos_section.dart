import 'package:design_system/utils/extensions.dart';
import 'package:feature_wonderous/api/wonder.dart';
import 'package:feature_wonderous/api/wonder_client.dart';
import 'package:feature_wonderous/ui/common.dart';
import 'package:feature_wonderous/ui/formatters.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart'
    hide Divider, Card;

final class WonderPhotosSection extends StatelessWidget {
  final Wonder wonder;
  const WonderPhotosSection({super.key, required this.wonder});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wonderClient = vyuh.di.get<WonderClient>();

    return WonderSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WonderHeader(wonder: wonder),
          SizedBox(height: theme.spacing.s8),
          FutureBuilder(
            future: wonderClient.fetchPhotos(wonder.unsplashCollectionId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return vyuh.widgetBuilder.contentLoader(context);
              }

              if (snapshot.hasError) {
                return vyuh.widgetBuilder.errorView(
                  context,
                  title: 'Failed to load photos',
                  error: snapshot.error,
                );
              }

              final photos = snapshot.data as List<Photo>;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: theme.spacing.s8,
                  mainAxisSpacing: theme.spacing.s8,
                  childAspectRatio: theme.aspectRatio.threeToTwo,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return ContentImage(
                    url: photo.url.toString(),
                    width: photo.width.toDouble(),
                    height: photo.height.toDouble(),
                    fit: BoxFit.cover,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class WonderEvent extends StatelessWidget {
  final Event event;
  const WonderEvent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final year = event.year.formattedYear.split(' ').join('\n');
    return Container(
      padding: EdgeInsets.all(theme.spacing.s8),
      margin: EdgeInsets.symmetric(vertical: theme.spacing.s8),
      color: theme.colorScheme.surfaceDim,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 70,
              child: Text(
                year,
                textAlign: TextAlign.right,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.apply(color: Colors.black),
              ),
            ),
            SizedBox(width: theme.sizing.s2),
            VerticalDivider(color: theme.colorScheme.surface),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: theme.spacing.s8),
                child: Text(
                  event.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
