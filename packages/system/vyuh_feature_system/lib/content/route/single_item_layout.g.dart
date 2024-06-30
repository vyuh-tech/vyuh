// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_item_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleItemLayout _$SingleItemLayoutFromJson(Map<String, dynamic> json) =>
    SingleItemLayout(
      useSafeArea: json['useSafeArea'] as bool? ?? false,
      showAppBar: json['showAppBar'] as bool? ?? false,
      actions: (json['actions'] as List<dynamic>?)
          ?.map((e) => MenuAction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
