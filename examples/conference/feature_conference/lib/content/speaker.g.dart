// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speaker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeakerSocial _$SpeakerSocialFromJson(Map<String, dynamic> json) =>
    SpeakerSocial(
      twitter: json['twitter'] as String?,
      github: json['github'] as String?,
      linkedin: json['linkedin'] as String?,
      website: json['website'] as String?,
    );

Speaker _$SpeakerFromJson(Map<String, dynamic> json) => Speaker(
      id: json['_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      tagline: json['tagline'] as String?,
      bio: json['bio'] as String?,
      photo: json['photo'] == null
          ? null
          : ImageReference.fromJson(json['photo'] as Map<String, dynamic>),
      social: json['social'] == null
          ? null
          : SpeakerSocial.fromJson(json['social'] as Map<String, dynamic>),
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );
