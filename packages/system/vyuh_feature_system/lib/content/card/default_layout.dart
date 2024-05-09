import 'package:flutter/material.dart' as f;
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as e;

part 'default_layout.g.dart';

@JsonSerializable()
class DefaultCardLayout extends LayoutConfiguration<e.Card> {
  static const schemaName = '${e.Card.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Card Layout',
    fromJson: DefaultCardLayout.fromJson,
  );

  @JsonKey(defaultValue: '')
  final String title;

  DefaultCardLayout({required this.title}) : super(schemaType: schemaName);

  factory DefaultCardLayout.fromJson(Map<String, dynamic> json) =>
      _$DefaultCardLayoutFromJson(json);

  @override
  Widget build(BuildContext context, e.Card content) {
    final theme = Theme.of(context);

    final blockLength = content.content?.blocks?.length;
    final hasBlockContent = blockLength != null && blockLength > 0;

    return e.PressEffect(
      onTap: content.action != null
          ? (context) => content.action!.execute(context)
          : null,
      child: f.Card(
        color: theme.cardColor,
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (content.image != null || content.imageUrl != null)
              Flexible(
                child: e.ContentImage(
                  url: content.imageUrl?.toString(),
                  ref: content.image,
                  fit: BoxFit.contain,
                ),
              ),
            f.Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (content.title != null)
                    Text(
                      content.title!,
                      style: theme.textTheme.titleMedium,
                    ),
                  if (content.description != null) Text(content.description!),
                  if (hasBlockContent)
                    Flexible(
                        child: vyuh.content
                            .buildContent(context, content.content!)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
