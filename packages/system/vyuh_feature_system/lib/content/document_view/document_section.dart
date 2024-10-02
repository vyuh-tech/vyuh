import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/content/document_view/document_section_layout.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'document_section.g.dart';

@JsonSerializable()
final class DocumentSectionView extends ContentItem {
  static const schemaName = '${DocumentView.schemaName}.section';

  @JsonKey(fromJson: typeFromFirstOfListJson<DocumentSectionConfiguration>)
  final DocumentSectionConfiguration? configuration;

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Document Section View',
    fromJson: DocumentSectionView.fromJson,
  );

  static final contentBuilder = _DocumentSectionViewContentBuilder();

  DocumentSectionView({this.configuration}) : super(schemaType: schemaName);

  factory DocumentSectionView.fromJson(Map<String, dynamic> json) =>
      _$DocumentSectionViewFromJson(json);
}

abstract class DocumentSectionConfiguration<TDocument extends DocumentItem>
    implements SchemaItem {
  @override
  final String schemaType;

  final String? title;

  DocumentSectionConfiguration({required this.schemaType, this.title});

  factory DocumentSectionConfiguration.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError('This must be implemented by the subclass');

  Widget build(BuildContext context, TDocument document);
}

class DocumentSectionViewDescriptor extends ContentDescriptor {
  final List<TypeDescriptor<DocumentSectionConfiguration>>? configurations;

  DocumentSectionViewDescriptor({this.configurations, super.layouts})
      : super(
            schemaType: DocumentSectionView.schemaName,
            title: 'Document Section View');
}

final class _DocumentSectionViewContentBuilder extends ContentBuilder {
  _DocumentSectionViewContentBuilder()
      : super(
          content: DocumentSectionView.typeDescriptor,
          defaultLayout: DefaultDocumentSectionViewLayout(),
          defaultLayoutDescriptor:
              DefaultDocumentSectionViewLayout.typeDescriptor,
        );

  @override
  void init(List<ContentDescriptor> descriptors) {
    final ds = descriptors.cast<DocumentSectionViewDescriptor>();

    registerDescriptors<DocumentSectionConfiguration>(ds.expand((element) =>
        element.configurations ??
        <TypeDescriptor<DocumentSectionConfiguration>>[]));

    super.init(descriptors);
  }
}
