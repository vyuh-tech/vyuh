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

  /// The scroll physics to use for the list view.
  /// It is [AlwaysScrollableScrollPhysics] by default.
  final ScrollPhysics scrollPhysics;

  const PortableText({
    super.key,
    required this.blocks,
    this.usePrimaryScroller = false,
    this.shrinkwrap = true,
    this.scrollPhysics = const AlwaysScrollableScrollPhysics(),
  });

  @override
  Widget build(final BuildContext context) {
    return ListView.builder(
      primary: usePrimaryScroller,
      physics: scrollPhysics,
      shrinkWrap: shrinkwrap,
      itemCount: blocks.length,
      padding: EdgeInsets.zero,
      itemBuilder: (final context, final index) {
        final item = blocks[index];
        final type = item.blockType;

        final builder = PortableTextConfig.shared.blocks[type];
        if (builder == null) {
          return ErrorView(message: 'Missing builder for block "$type"');
        }

        return builder(context, item);
      },
    );
  }
}
