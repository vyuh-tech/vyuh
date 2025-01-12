import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

export 'grid_layout.dart';

part 'default_layout.g.dart';

@JsonSerializable()
final class DefaultGroupLayout extends LayoutConfiguration<Group> {
  static const schemaName = '${Group.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Group Layout',
    fromJson: DefaultGroupLayout.fromJson,
    preview: () => DefaultGroupLayout(),
  );

  DefaultGroupLayout() : super(schemaType: schemaName);

  factory DefaultGroupLayout.fromJson(Map<String, dynamic> json) =>
      _$DefaultGroupLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Group content) {
    return _DefaultLayout(content: content);
  }
}

final class _DefaultLayout extends StatelessWidget {
  final Group content;

  const _DefaultLayout({required this.content});

  @override
  Widget build(BuildContext context) {
    return GroupLayoutContainer(
      content: content,
      body: Carousel(content: content),
    );
  }
}

final class GroupLayoutContainer extends StatelessWidget {
  final Group content;
  final Widget body;

  const GroupLayoutContainer(
      {super.key, required this.content, required this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final hasHeader = (content.title != null && content.title!.isNotEmpty) ||
        (content.description != null && content.description!.isNotEmpty);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (content.title != null && content.title!.isNotEmpty)
            Text(
              content.title!,
              style: theme.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (content.description != null && content.description!.isNotEmpty)
            Text(
              content.description!,
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (hasHeader)
            const SizedBox(
              height: 4.0,
            ),
          body,
        ],
      ),
    );
  }
}
