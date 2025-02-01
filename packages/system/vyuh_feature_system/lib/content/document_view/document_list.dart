import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/content/document_view/document_list_layout.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'document_list.g.dart';

@JsonSerializable()
final class DocumentListView extends ContentItem {
  static const schemaName = 'vyuh.document.list';

  @JsonKey(fromJson: typeFromFirstOfListJson<QueryConfiguration>)
  final QueryConfiguration? query;

  @JsonKey(fromJson: typeFromFirstOfListJson<DocumentItemConfiguration>)
  final DocumentItemConfiguration? listItem;

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Document List View',
    fromJson: DocumentListView.fromJson,
  );

  static final contentBuilder = _DocumentListViewContentBuilder();

  DocumentListView({
    this.listItem,
    this.query,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName) {
    assert(listItem != null, 'A list item configuration must be provided');
    assert(query != null, 'A query configuration must be provided');
  }

  factory DocumentListView.fromJson(Map<String, dynamic> json) =>
      _$DocumentListViewFromJson(json);
}

abstract class DocumentItemConfiguration<TDocument extends DocumentItem>
    implements SchemaItem {
  @override
  final String schemaType;

  final String? title;

  DocumentItemConfiguration({required this.schemaType, this.title});

  factory DocumentItemConfiguration.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError('This must be implemented by the subclass');

  Widget build(BuildContext context, TDocument document);
}

class DocumentListViewDescriptor extends ContentDescriptor {
  final List<TypeDescriptor<DocumentItem>>? documentTypes;
  final List<TypeDescriptor<DocumentItemConfiguration>>? listItemConfigurations;
  final List<TypeDescriptor<QueryConfiguration>>? queryConfigurations;

  DocumentListViewDescriptor({
    this.documentTypes,
    this.queryConfigurations,
    this.listItemConfigurations,
    super.layouts,
  }) : super(
            schemaType: DocumentListView.schemaName,
            title: 'Document List View');
}

final class _DocumentListViewContentBuilder extends ContentBuilder {
  _DocumentListViewContentBuilder()
      : super(
          content: DocumentListView.typeDescriptor,
          defaultLayout: DefaultDocumentListViewLayout(),
          defaultLayoutDescriptor: DefaultDocumentListViewLayout.typeDescriptor,
        );

  @override
  void init(List<ContentDescriptor> descriptors) {
    final ds = descriptors.cast<DocumentListViewDescriptor>();

    registerDescriptors<DocumentItem>(
      ds.expand((element) =>
          element.documentTypes ?? <TypeDescriptor<DocumentItem>>[]),
      checkUnique: true,
    );

    registerDescriptors<QueryConfiguration>(ds.expand((element) =>
        element.queryConfigurations ?? <TypeDescriptor<QueryConfiguration>>[]));

    registerDescriptors<DocumentItemConfiguration>(ds.expand((element) =>
        element.listItemConfigurations ??
        <TypeDescriptor<DocumentItemConfiguration>>[]));

    super.init(descriptors);
  }
}
