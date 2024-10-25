// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wonder_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WonderMiniInfo _$WonderMiniInfoFromJson(Map<String, dynamic> json) =>
    WonderMiniInfo(
      identifier: json['identifier'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      icon: ImageReference.fromJson(json['icon'] as Map<String, dynamic>),
      image: ImageReference.fromJson(json['image'] as Map<String, dynamic>),
      color: Wonder.colorFromJson(json['hexColor'] as String),
    );

WonderListItemConfiguration _$WonderListItemConfigurationFromJson(
        Map<String, dynamic> json) =>
    WonderListItemConfiguration(
      title: json['title'] as String?,
    );
