import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

import 'no_preview_card.dart';

/// A widget to display a preview of a content item.
///
final class Preview extends StatelessWidget {
  /// The content builder to preview.
  ///
  final ContentBuilder builder;

  /// The layout to preview.
  ///
  final TypeDescriptor<LayoutConfiguration<ContentItem>> layout;

  /// Creates a new preview widget.
  ///
  const Preview({
    super.key,
    required this.builder,
    required this.layout,
  });

  @override
  Widget build(BuildContext context) {
    final content = builder.content.preview?.call();
    final contentLayout = layout.preview?.call();

    final widget = (content == null || contentLayout == null)
        ? null
        : PreviewContext(
            content: content,
            layout: contentLayout,
            child: Builder(
              builder: (context) => vyuh.content
                  .buildContent(context, content, layout: contentLayout),
            ),
          );

    final message = [
      if (content == null) '${builder.content.runtimeType}',
      if (contentLayout == null) '${layout.runtimeType}',
    ].join(' and ');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: widget ??
          NoPreviewCard(
            title: layout.title,
            message: message,
          ),
    );
  }
}
