// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentView _$DocumentViewFromJson(Map<String, dynamic> json) => DocumentView(
      title: json['title'] as String?,
      reference: json['reference'] == null
          ? null
          : ObjectReference.fromJson(json['reference'] as Map<String, dynamic>),
      loadStrategy: $enumDecodeNullable(
              _$DocumentLoadStrategyEnumMap, json['loadStrategy']) ??
          DocumentLoadStrategy.reference,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ContentItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      query: typeFromFirstOfListJson(json['query']),
      layout: typeFromFirstOfListJson(json['layout']),
    );

const _$DocumentLoadStrategyEnumMap = {
  DocumentLoadStrategy.reference: 'reference',
  DocumentLoadStrategy.query: 'query',
};

DefaultDocumentViewLayout _$DefaultDocumentViewLayoutFromJson(
        Map<String, dynamic> json) =>
    DefaultDocumentViewLayout();

DocumentViewConditionalLayout _$DocumentViewConditionalLayoutFromJson(
        Map<String, dynamic> json) =>
    DocumentViewConditionalLayout(
      cases: (json['cases'] as List<dynamic>)
          .map((e) => LayoutCaseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      defaultCase: json['defaultCase'] as String,
      condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
    );
