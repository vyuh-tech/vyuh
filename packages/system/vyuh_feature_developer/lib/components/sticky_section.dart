import 'package:flutter/material.dart';
import 'package:vyuh_feature_developer/components/items.dart';

/// A widget to display a sticky section.
///
final class StickySection extends StatelessWidget {
  /// The title of the sticky section.
  ///
  final String title;

  /// The sliver to display in the sticky section.
  ///
  final Widget? sliver;

  /// The color of the header.
  ///
  final Color? headerColor;

  /// Creates a new sticky section widget.
  ///
  const StickySection(
      {super.key, required this.title, required this.sliver, this.headerColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverMainAxisGroup(
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: true,
          snap: true,
          backgroundColor: headerColor ?? theme.colorScheme.inverseSurface,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(title,
              style: theme.textTheme.labelLarge
                  ?.apply(color: theme.colorScheme.onInverseSurface),
              textAlign: TextAlign.center),
        ),
        sliver ?? const SliverToBoxAdapter(child: EmptyItemTile()),
      ],
    );
  }
}
