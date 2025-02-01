import 'package:flutter/material.dart' hide Action;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'document.g.dart';

@JsonSerializable()
final class Document extends ContentItem {
  static const schemaName = 'vyuh.document';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Document',
    fromJson: Document.fromJson,
  );

  static final descriptor = ContentDescriptor.createDefault(
      schemaType: schemaName, title: 'Document Descriptor');

  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayout: DocumentDefaultLayout(),
    defaultLayoutDescriptor: DocumentDefaultLayout.typeDescriptor,
  );

  final String? title;
  final String? description;

  @JsonKey(fromJson: typeFromFirstOfListJson<ContentItem>)
  final ContentItem? item;

  Document({
    this.title,
    this.description,
    this.item,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);
}

final class DocumentDescriptor extends ContentDescriptor {
  DocumentDescriptor({super.layouts = const []})
      : super(schemaType: Document.schemaName, title: 'Document');
}

@JsonSerializable()
final class DocumentDefaultLayout extends LayoutConfiguration<Document> {
  static const schemaName = '${Document.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: DocumentDefaultLayout.fromJson,
    title: 'Document Default Layout',
  );

  DocumentDefaultLayout() : super(schemaType: schemaName);

  factory DocumentDefaultLayout.fromJson(Map<String, dynamic> json) =>
      _$DocumentDefaultLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Document content) {
    final theme = Theme.of(context);

    return Column(
      spacing: 4,
      children: [
        if (content.title != null)
          Text(content.title!, style: theme.textTheme.titleMedium),
        if (content.description != null) Text(content.description!),
        if (content.item != null)
          Expanded(
            child:
                VyuhContentBinding.content.buildContent(context, content.item!),
          ),
      ],
    );
  }
}
