import 'package:flutter/material.dart';

import '../flutter_sanity_portable_text.dart';

/// A widget that renders a list of PortableBlockItems. This widget is the main entry point for
/// rendering Portable Text content. It is responsible for rendering the entire content of a Portable
/// Text document, including all blocks and marks. It relies on the [PortableTextConfig] to determine
/// the visual representation of each block.
class PortableText extends StatelessWidget {
  /// The list of block items to render.
  final List<PortableBlockItem> blocks;

  /// Whether the to treat this as a primary scroll view. This is useful when you want to have a
  /// single scroll view for the entire content. It is false by default.
  final bool usePrimaryScroller;

  /// Whether to shrink-wrap the list view. This is useful when you want the list view to take up
  /// only the space it needs. It is true by default.
  final bool shrinkwrap;

  const PortableText({
    super.key,
    required this.blocks,
    this.usePrimaryScroller = false,
    this.shrinkwrap = true,
  });

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      primary: usePrimaryScroller,
      shrinkWrap: shrinkwrap,
      itemCount: blocks.length,
      padding: EdgeInsets.zero,
      itemBuilder: (final context, final index) {
        final item = blocks[index];
        final type = item.blockType;

        final builder = PortableTextConfig.shared.blocks[type];
        if (builder == null) {
          return Container(
            color: theme.colorScheme.onErrorContainer,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: theme.colorScheme.error),
                const SizedBox(width: 8),
                Text(
                  'Missing builder for: $type',
                  style: theme.textTheme.bodyMedium
                      ?.apply(color: theme.colorScheme.errorContainer),
                ),
              ],
            ),
          );
        }

        return builder(context, item);
      },
    );
  }
}
