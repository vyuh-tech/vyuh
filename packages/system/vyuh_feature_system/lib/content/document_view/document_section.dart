import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/content/document_view/document_section_layout.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'document_section.g.dart';

@JsonSerializable()
final class DocumentSectionView extends ContentItem {
  static const schemaName = '${DocumentView.schemaName}.section';

  @JsonKey(fromJson: typeFromFirstOfListJson<DocumentItemConfiguration>)
  final DocumentItemConfiguration? configuration;

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Document Section View',
    fromJson: DocumentSectionView.fromJson,
  );

  static final contentBuilder = _DocumentSectionViewContentBuilder();

  DocumentSectionView({
    this.configuration,
    super.layout,
  }) : super(schemaType: schemaName);

  factory DocumentSectionView.fromJson(Map<String, dynamic> json) =>
      _$DocumentSectionViewFromJson(json);
}

class DocumentSectionViewDescriptor extends ContentDescriptor {
  final List<TypeDescriptor<DocumentItemConfiguration>>? configurations;

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

    registerDescriptors<DocumentItemConfiguration>(ds.expand((element) =>
        element.configurations ??
        <TypeDescriptor<DocumentItemConfiguration>>[]));

    super.init(descriptors);
  }
}
