// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_section_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefaultDocumentSectionViewLayout _$DefaultDocumentSectionViewLayoutFromJson(
        Map<String, dynamic> json) =>
    DefaultDocumentSectionViewLayout();

DocumentSectionViewConditionalLayout
    _$DocumentSectionViewConditionalLayoutFromJson(Map<String, dynamic> json) =>
        DocumentSectionViewConditionalLayout(
          cases: (json['cases'] as List<dynamic>)
              .map((e) => LayoutCaseItem.fromJson(e as Map<String, dynamic>))
              .toList(),
          defaultCase: json['defaultCase'] as String,
          condition:
              Condition.fromJson(json['condition'] as Map<String, dynamic>),
        );
