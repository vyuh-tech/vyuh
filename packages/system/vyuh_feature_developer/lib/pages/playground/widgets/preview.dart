import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

import 'no_preview_card.dart';

final class Preview extends StatelessWidget {
  final ContentBuilder builder;
  final TypeDescriptor<LayoutConfiguration<ContentItem>> layout;

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
