import 'package:flutter/material.dart';

import '../flutter_sanity_portable_text.dart';

class PortableText extends StatelessWidget {
  final List<PortableBlockItem> blocks;

  final bool usePrimaryScroller;

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
