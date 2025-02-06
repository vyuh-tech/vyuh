import 'package:flutter/material.dart' hide Action;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/ui/content_items_scrollview.dart';

part 'document.g.dart';

/// A document is a content item that represents a structured document.
/// It contains a set of fields like title, description, and content that are defined by the document's schema.
/// The document is used to display structured content in the app.
///
@JsonSerializable()
final class Document extends ContentItem {
  static const schemaName = 'vyuh.document';

  /// The default type descriptor for documents. Used for deserialization.
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Document',
    fromJson: Document.fromJson,
  );

  /// Used for extending the layouts of documents
  static final descriptor = ContentDescriptor.createDefault(
      schemaType: schemaName, title: 'Document Descriptor');

  /// The default content builder for documents, which assembles all the
  /// descriptors and constructs the final document representation.
  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayout: DocumentDefaultLayout(),
    defaultLayoutDescriptor: DocumentDefaultLayout.typeDescriptor,
  );

  /// The title of the document.
  /// This is used to display the title of the document in the app.
  /// The title is typically displayed in the app's top navigation bar or in the document's header.
  final String? title;

  /// The description of the document.
  /// This is an optional field and is used to provide additional information about the document.
  final String? description;

  /// The content of the document.
  /// This is the actual content of the document.
  /// The content is typically displayed in the document's body.
  ///
  @JsonKey(fromJson: itemsList)
  final List<ContentItem>? items;

  static List<ContentItem>? itemsList(dynamic json) =>
      listFromJson<ContentItem>(json);

  /// Creates a new document with the given title, description, and content.
  Document({
    this.title,
    this.description,
    this.items,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);
}

enum DocumentRenderMode { single, list }

/// The default layout for documents.
/// It shows a column view of title, description, and content.
@JsonSerializable()
final class DocumentDefaultLayout extends LayoutConfiguration<Document> {
  static const schemaName = '${Document.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: DocumentDefaultLayout.fromJson,
    title: 'Document Default Layout',
  );

  final DocumentRenderMode mode;
  DocumentDefaultLayout({this.mode = DocumentRenderMode.single})
      : super(schemaType: schemaName);

  factory DocumentDefaultLayout.fromJson(Map<String, dynamic> json) =>
      _$DocumentDefaultLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Document content) {
    final theme = Theme.of(context);
    final mode = (content.layout as DocumentDefaultLayout?)?.mode ??
        DocumentRenderMode.single;

    return Column(
      spacing: 4,
      children: [
        if (content.title != null)
          Text(content.title!, style: theme.textTheme.titleMedium),
        if (content.description != null) Text(content.description!),
        if (content.items != null && content.items!.isNotEmpty)
          Expanded(
              child: switch (mode) {
            DocumentRenderMode.single => VyuhContentBinding.content
                .buildContent(context, content.items!.first),
            _ => ContentItemsScrollView(items: content.items!)
          }),
      ],
    );
  }
}
