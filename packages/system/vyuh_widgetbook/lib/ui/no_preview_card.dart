import 'package:flutter/material.dart';
import 'package:vyuh_core/plugin/content/content_item.dart';

final class NoPreviewCard extends StatelessWidget {
  final String title;
  final ContentItem? content;
  final LayoutConfiguration? layout;

  final Type contentType;
  final Type layoutType;

  const NoPreviewCard({
    super.key,
    required this.title,
    this.content,
    this.layout,
    required this.contentType,
    required this.layoutType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final message = [
      if (content == null) '$contentType',
      if (layout == null) '$layoutType',
    ].join(' and ');

    return Card(
      color: theme.colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '''
No Preview available for $title.
         
Make sure to supply the 'preview' parameter for $message.
          ''',
          style: theme.textTheme.labelLarge?.apply(
            color: theme.colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }
}
