import 'package:flutter/material.dart';
import 'package:vyuh_core/plugin/content/content_item.dart';

final class DebugModifier extends ContentModifierConfiguration {
  DebugModifier() : super(schemaType: 'vyuh.content.modifier.debug');

  @override
  Widget build(BuildContext context, Widget child, ContentItem content) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        child,
        Positioned(
          top: 2,
          right: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            color: theme.colorScheme.inverseSurface.withValues(alpha: 0.5),
            child: Text(
              content.schemaType,
              style: TextStyle(
                color: theme.colorScheme.onInverseSurface,
                fontSize: 9,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
