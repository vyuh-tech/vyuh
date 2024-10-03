// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_list_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefaultDocumentListViewLayout _$DefaultDocumentListViewLayoutFromJson(
        Map<String, dynamic> json) =>
    DefaultDocumentListViewLayout(
      aspectRatio: (json['aspectRatio'] as num?)?.toDouble() ?? 1.0,
      mode: $enumDecodeNullable(_$ListViewModeEnumMap, json['mode']) ??
          ListViewMode.list,
      columns: (json['columns'] as num?)?.toInt() ?? 2,
    );

const _$ListViewModeEnumMap = {
  ListViewMode.list: 'list',
  ListViewMode.grid: 'grid',
};

DocumentListViewConditionalLayout _$DocumentListViewConditionalLayoutFromJson(
        Map<String, dynamic> json) =>
    DocumentListViewConditionalLayout(
      cases: (json['cases'] as List<dynamic>)
          .map((e) => LayoutCaseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      defaultCase: json['defaultCase'] as String,
      condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
    );
