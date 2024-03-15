import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class StickySection extends StatelessWidget {
  final String title;

  final Widget? sliver;

  const StickySection({super.key, required this.title, required this.sliver});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverStickyHeader(
      header: Container(
        color: theme.colorScheme.inverseSurface,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 2),
        child: Text(title,
            style: theme.textTheme.labelLarge
                ?.apply(color: theme.colorScheme.onInverseSurface),
            textAlign: TextAlign.center),
      ),
      sliver: sliver ??
          const SliverToBoxAdapter(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('None defined.'),
          )),
    );
  }
}
