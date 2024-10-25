import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

final class PhotoCard extends StatelessWidget {
  final String? title;

  final bool showStats;

  final Photo photo;

  final VoidCallback onTap;

  const PhotoCard({
    super.key,
    this.title,
    this.showStats = false,
    required this.photo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _buildDetailView(context),
    );
  }

  Widget _buildDetailView(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Hero(
            tag: photo.id,
            child: ContentImage(url: photo.urls.regular.toString()),
          ),
        ),
        if (showStats)
          Positioned(
            right: 4,
            top: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.start,
                  children: [
                    if (photo.likes > 0)
                      _Chip(
                        icon: Icons.favorite,
                        label: NumberFormat.compact().format(photo.likes),
                      ),
                    if (photo.downloads != null && photo.downloads! > 0)
                      _Chip(
                        icon: Icons.download,
                        label: NumberFormat.compact().format(photo.downloads!),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                _Chip(
                    label: 'by ${photo.user.name}',
                    padding: const EdgeInsets.symmetric(horizontal: 4))
              ],
            ),
          ),
        if (title != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _Chip(
                label: title!,
                borderRadius: const BorderRadius.all(Radius.zero)),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  const _Chip({
    required this.label,
    this.icon,
    this.padding = const EdgeInsets.all(4),
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.inverseSurface.withOpacity(0.75),
        borderRadius: borderRadius,
      ),
      padding: padding,
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 16,
              color: theme.colorScheme.onInverseSurface,
            ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall!
                .apply(color: theme.colorScheme.onInverseSurface),
          ),
        ],
      ),
    );
  }
}
