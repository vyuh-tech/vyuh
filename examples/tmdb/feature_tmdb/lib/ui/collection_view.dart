import 'dart:math';

import 'package:design_system/design_system.dart';
import 'package:feature_tmdb/content/enums/config_enum.dart';
import 'package:feature_tmdb/ui/formatters.dart';
import 'package:feature_tmdb/ui/section_title.dart';
import 'package:feature_tmdb/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Divider;

typedef ItemWidgetBuilder<T> = Widget? Function(
  BuildContext context,
  T item,
);

enum MediaCardType { home, recommendation, watchlist }

final class CollectionView<T> extends StatelessWidget {
  final List<T> items;
  final ItemWidgetBuilder itemBuilder;
  final String title;
  final MediaCardType mediaCardType;
  final ListRepresentation variant;
  final void Function()? onViewAllTap;

  const CollectionView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.title,
    this.mediaCardType = MediaCardType.home,
    required this.variant,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return empty;
    }

    final size = MediaQuery.of(context).size;
    final listItems =
        variant == ListRepresentation.short ? items.toList() : items;

    if (variant == ListRepresentation.short) {
      return _ShortListView<T>(
        title: title,
        onViewAllTap: onViewAllTap,
        mediaCardType: mediaCardType,
        items: listItems,
        itemBuilder: itemBuilder,
      );
    }

    return _FullListView(
      size: size,
      title: title,
      items: listItems,
      itemBuilder: itemBuilder,
    );
  }
}

class _FullListView<T> extends StatelessWidget {
  const _FullListView({
    super.key,
    required this.size,
    required this.title,
    required this.items,
    required this.itemBuilder,
  });

  final Size size;
  final String title;
  final List<T> items;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LimitedBox(
      maxHeight: MediaQuery.sizeOf(context).height * 0.5,
      child: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.s32,
            vertical: theme.spacing.s16,
          ),
          child: const Divider(),
        ),
        itemBuilder: (context, index) => itemBuilder(context, items[index]),
      ),
    );
  }
}

class _ShortListView<T> extends StatelessWidget {
  const _ShortListView({
    required this.title,
    this.onViewAllTap,
    this.mediaCardType = MediaCardType.home,
    required this.items,
    required this.itemBuilder,
  });

  final MediaCardType mediaCardType;
  final String title;
  final void Function()? onViewAllTap;
  final List<T> items;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: theme.spacing.s32,
            right: theme.spacing.s16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SectionTitle(
                  title: title,
                ),
              ),
              if (items.shouldShowViewAll && onViewAllTap != null)
                TextButton(
                  onPressed: onViewAllTap,
                  child: Row(
                    children: [
                      Text(
                        'See All',
                        style: theme.tmdbTheme.labelMedium?.apply(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: theme.sizing.s6,
                        color: theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: theme.spacing.s24,
            right: theme.spacing.s20,
          ),
          child: BuildMediaCard<T>(
            itemBuilder: itemBuilder,
            mediaCardType: mediaCardType,
            items: items,
          ),
        ),
      ],
    );
  }
}

class BuildMediaCard<T> extends StatelessWidget {
  final MediaCardType mediaCardType;
  final ItemWidgetBuilder<T> itemBuilder;
  final List<T> items;

  const BuildMediaCard({
    super.key,
    this.mediaCardType = MediaCardType.home,
    required this.itemBuilder,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (mediaCardType == MediaCardType.recommendation) {
      return SizedBox(
        height: theme.sizing.width43(MediaQuery.of(context).size.height),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: theme.spacing.s8,
            crossAxisSpacing: theme.spacing.s8,
          ),
          itemCount: min(maxCountForMediaGridView, items.length),
          itemBuilder: (context, index) => itemBuilder(context, items[index]),
        ),
      );
    } else {
      return SizedBox(
        height: theme.sizing.s50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: min(maxCountForViewAll, items.length),
          itemBuilder: (context, index) => itemBuilder(context, items[index]),
        ),
      );
    }
  }
}
