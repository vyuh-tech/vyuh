// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grid_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GridGroupLayout _$GridGroupLayoutFromJson(Map<String, dynamic> json) =>
    GridGroupLayout(
      columns: (json['columns'] as num?)?.toInt() ?? 2,
      aspectRatio: (json['aspectRatio'] as num?)?.toDouble() ?? 1.0,
      scrollable: json['scrollable'] as bool? ?? false,
    );
