import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
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

    return SliverStickyHeader(
      header: Container(
        color: headerColor ?? theme.colorScheme.inverseSurface,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 2),
        child: Text(title,
            style: theme.textTheme.labelLarge
                ?.apply(color: theme.colorScheme.onInverseSurface),
            textAlign: TextAlign.center),
      ),
      sliver: sliver ?? const SliverToBoxAdapter(child: EmptyItemTile()),
    );
  }
}
