import 'package:flutter/material.dart' as f;
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/ui/text.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as e;

part 'default_layout.g.dart';

enum _CardRenderVariant {
  imageOnly,
  imageAndText,
  textOnly,
}

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

  final int maxDescriptionLines;

  DefaultCardLayout({required this.title, this.maxDescriptionLines = 2})
      : super(schemaType: schemaName);

  factory DefaultCardLayout.fromJson(Map<String, dynamic> json) =>
      _$DefaultCardLayoutFromJson(json);

  @override
  Widget build(BuildContext context, e.Card content) {
    final variant = _getVariant(content);

    final child = switch (variant) {
      _CardRenderVariant.imageOnly => _buildImageOnly(context, content),
      _CardRenderVariant.imageAndText => _buildImageAndText(context, content),
      _CardRenderVariant.textOnly => _buildTextOnly(context, content),
    };

    return e.PressEffect(
        onTap: content.action != null
            ? (context) => content.action!.execute(context)
            : null,
        child: child);
  }

  Widget _buildImageOnly(f.BuildContext context, e.Card content) {
    return f.Card(
      clipBehavior: Clip.antiAlias,
      child: e.ContentImage(
        url: content.imageUrl?.toString(),
        ref: content.image,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTextOnly(f.BuildContext context, e.Card content) {
    final theme = f.Theme.of(context);

    final blockLength = content.content?.blocks?.length;
    final hasBlockContent = blockLength != null && blockLength > 0;

    return f.Card(
      color: theme.cardColor,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          f.Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (content.title != null)
                  TitleText(
                    text: content.title!,
                    textAlign: TextAlign.center,
                  ),
                if (content.description != null)
                  SubtitleText(
                    text: content.description!,
                    textAlign: TextAlign.center,
                    maxLines: maxDescriptionLines,
                  ),
                if (hasBlockContent)
                  Flexible(
                      child:
                          vyuh.content.buildContent(context, content.content!)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildImageAndText(f.BuildContext context, e.Card content) {
    final theme = f.Theme.of(context);

    final blockLength = content.content?.blocks?.length;
    final hasBlockContent = blockLength != null && blockLength > 0;

    return f.Card(
      color: theme.cardColor,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: e.ContentImage(
              url: content.imageUrl?.toString(),
              ref: content.image,
              fit: BoxFit.cover,
            ),
          ),
          f.Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (content.title != null && content.title!.isNotEmpty)
                  TitleText(
                    text: content.title!,
                    textAlign: TextAlign.center,
                  ),
                if (content.description != null &&
                    content.description!.isNotEmpty)
                  SubtitleText(
                    text: content.description!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                if (hasBlockContent)
                  Flexible(
                      child:
                          vyuh.content.buildContent(context, content.content!)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _CardRenderVariant _getVariant(e.Card content) {
    if (content.image != null || content.imageUrl != null) {
      if (content.title != null ||
          content.description != null ||
          content.content?.blocks != null) {
        return _CardRenderVariant.imageAndText;
      } else {
        return _CardRenderVariant.imageOnly;
      }
    } else {
      return _CardRenderVariant.textOnly;
    }
  }
}
