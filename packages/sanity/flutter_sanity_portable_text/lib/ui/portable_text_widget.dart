import 'package:flutter/material.dart';

import '../flutter_sanity_portable_text.dart';

typedef BlockListBuilder = Widget Function(
    BuildContext, List<PortableBlockItem>);

/// A widget that renders a list of PortableBlockItems. This widget is the main entry point for
/// rendering Portable Text content. It is responsible for rendering the entire content of a Portable
/// Text document, including all blocks and marks. It relies on the [PortableTextConfig] to determine
/// the visual representation of each block.
class PortableText extends StatelessWidget {
  /// The list of block items to render.
  final List<PortableBlockItem> blocks;

  final BlockListBuilder listBuilder;

  const PortableText({
    super.key,
    required this.blocks,
    BlockListBuilder? listBuilder,
  }) : listBuilder = listBuilder ?? _defaultContainerBuilder;

  static Widget _defaultContainerBuilder(
          BuildContext context, List<PortableBlockItem> blocks) =>
      defaultListBuilder(context, blocks: blocks);

  @override
  Widget build(final BuildContext context) => listBuilder(context, blocks);
}

/// Default container-builder for PortableText blocks.
/// It uses a ListView.builder to render the blocks.
Widget defaultListBuilder(
  BuildContext context, {
  required List<PortableBlockItem> blocks,
  bool isPrimary = false,
  bool shrinkwrap = true,
  ScrollPhysics scrollPhysics = const NeverScrollableScrollPhysics(),
}) {
  return ListView.builder(
    primary: isPrimary,
    physics: scrollPhysics,
    shrinkWrap: shrinkwrap,
    itemCount: blocks.length,
    padding: EdgeInsets.zero,
    itemBuilder: (final context, final index) =>
        PortableTextConfig.shared.buildBlock(context, blocks[index]),
  );
}
