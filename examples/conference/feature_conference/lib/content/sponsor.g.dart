// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sponsor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sponsor _$SponsorFromJson(Map<String, dynamic> json) => Sponsor(
      id: json['_id'] as String,
      name: json['name'] as String,
      logo: json['logo'] == null
          ? null
          : ImageReference.fromJson(json['logo'] as Map<String, dynamic>),
      url: json['url'] as String?,
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );
