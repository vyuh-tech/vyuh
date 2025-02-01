import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'document_section_layout.g.dart';

@JsonSerializable()
final class DefaultDocumentSectionViewLayout
    extends LayoutConfiguration<DocumentSectionView> {
  static const schemaName = '${DocumentSectionView.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Document Section View Layout',
    fromJson: DefaultDocumentSectionViewLayout.fromJson,
  );

  DefaultDocumentSectionViewLayout() : super(schemaType: schemaName);

  factory DefaultDocumentSectionViewLayout.fromJson(
          Map<String, dynamic> json) =>
      _$DefaultDocumentSectionViewLayoutFromJson(json);

  @override
  Widget build(BuildContext context, DocumentSectionView content) {
    if (content.configuration == null) {
      return VyuhBinding.instance.widgetBuilder.errorView(
        context,
        title: 'Cannot render section',
        error: 'No configuration found for this document section',
      );
    }

    final docWidgetState = DocumentViewBuilderState.of(context);

    return Observer(builder: (context) {
      final snapshot = docWidgetState.document<DocumentItem>();

      if (snapshot.status == FutureStatus.pending) {
        return VyuhBinding.instance.widgetBuilder.contentLoader(context);
      }

      if (snapshot.result == FutureStatus.rejected) {
        return VyuhBinding.instance.widgetBuilder.errorView(
          context,
          title: 'No document found',
          error: snapshot.error,
        );
      }

      return content.configuration!.build(context, snapshot.result!);
    });
  }
}

@JsonSerializable()
final class DocumentSectionViewConditionalLayout
    extends ConditionalLayout<DocumentSectionView> {
  static const schemaName =
      '${DocumentSectionView.schemaName}.layout.conditional';

  static final typeDescriptor = TypeDescriptor(
    schemaType: DocumentSectionViewConditionalLayout.schemaName,
    title: 'DocumentSectionView Conditional Layout',
    fromJson: DocumentSectionViewConditionalLayout.fromJson,
  );

  DocumentSectionViewConditionalLayout({
    required super.cases,
    required super.defaultCase,
    required super.condition,
  }) : super(schemaType: schemaName);

  factory DocumentSectionViewConditionalLayout.fromJson(
          Map<String, dynamic> json) =>
      _$DocumentSectionViewConditionalLayoutFromJson(json);
}
