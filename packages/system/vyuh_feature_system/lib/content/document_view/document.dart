import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/content/document_view/document_view_widget.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'document.g.dart';

enum DocumentLoadStrategy {
  reference,
  query,
}

@JsonSerializable()
final class DocumentView extends ContentItem {
  final String? title;
  final ObjectReference? reference;
  final DocumentLoadStrategy loadStrategy;

  final List<ContentItem> items;

  @JsonKey(fromJson: typeFromFirstOfListJson<QueryConfiguration>)
  final QueryConfiguration? query;

  static const schemaName = 'vyuh.document';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Document View',
    fromJson: DocumentView.fromJson,
  );

  static final contentBuilder = _DocumentViewContentBuilder();

  DocumentView({
    this.title,
    this.reference,
    this.loadStrategy = DocumentLoadStrategy.reference,
    this.items = const [],
    required this.query,
  }) : super(schemaType: schemaName) {
    if (loadStrategy == DocumentLoadStrategy.reference) {
      assert(reference != null,
          'A document-reference is required when the loadStrategy is set to "reference"');
    }

    if (loadStrategy == DocumentLoadStrategy.query) {
      assert(query != null,
          'A query-configuration is required when the loadStrategy is set to "query"');
    }

    assert(items.isNotEmpty, 'There has to be at least one section to render.');
  }

  factory DocumentView.fromJson(Map<String, dynamic> json) =>
      _$DocumentViewFromJson(json);
}

@JsonSerializable()
final class DefaultDocumentViewLayout
    extends LayoutConfiguration<DocumentView> {
  static const schemaName = '${DocumentView.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Document View Layout',
    fromJson: DefaultDocumentViewLayout.fromJson,
  );

  DefaultDocumentViewLayout() : super(schemaType: schemaName);

  factory DefaultDocumentViewLayout.fromJson(Map<String, dynamic> json) =>
      _$DefaultDocumentViewLayoutFromJson(json);

  @override
  Widget build(BuildContext context, DocumentView content) {
    return DocumentViewWidget(document: content);
  }
}

abstract class QueryConfiguration implements SchemaItem {
  @override
  final String schemaType;

  QueryConfiguration({required this.schemaType});

  factory QueryConfiguration.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError(
          'This must be implemented by the QueryConfiguration subclass');

  String? buildQuery(BuildContext context);
}

class DocumentViewDescriptor extends ContentDescriptor {
  final List<TypeDescriptor<DocumentItem>>? documentTypes;
  final List<TypeDescriptor<QueryConfiguration>>? queries;

  DocumentViewDescriptor({this.queries, this.documentTypes, super.layouts})
      : super(schemaType: DocumentView.schemaName, title: 'Document View');
}

final class _DocumentViewContentBuilder extends ContentBuilder {
  _DocumentViewContentBuilder()
      : super(
          content: DocumentView.typeDescriptor,
          defaultLayout: DefaultDocumentViewLayout(),
          defaultLayoutDescriptor: DefaultDocumentViewLayout.typeDescriptor,
        );

  @override
  void init(List<ContentDescriptor> descriptors) {
    final ds = descriptors.cast<DocumentViewDescriptor>();

    registerDescriptors<QueryConfiguration>(ds.expand((element) =>
        element.queries ?? <TypeDescriptor<QueryConfiguration>>[]));

    registerDescriptors<DocumentItem>(ds.expand((element) =>
        element.documentTypes ?? <TypeDescriptor<DocumentItem>>[]));

    super.init(descriptors);
  }
}

@JsonSerializable()
final class DocumentViewConditionalLayout
    extends ConditionalLayout<DocumentView> {
  static const schemaName = '${DocumentView.schemaName}.layout.conditional';

  static final typeDescriptor = TypeDescriptor(
    schemaType: DocumentViewConditionalLayout.schemaName,
    title: 'DocumentView Conditional Layout',
    fromJson: DocumentViewConditionalLayout.fromJson,
  );

  DocumentViewConditionalLayout({
    required super.cases,
    required super.defaultCase,
    required super.condition,
  }) : super(schemaType: schemaName);

  factory DocumentViewConditionalLayout.fromJson(Map<String, dynamic> json) =>
      _$DocumentViewConditionalLayoutFromJson(json);
}
