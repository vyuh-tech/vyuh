// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oauth_signin_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuthSignInLayout _$OAuthSignInLayoutFromJson(Map<String, dynamic> json) =>
    OAuthSignInLayout(
      type: $enumDecodeNullable(_$OAuthLayoutTypeEnumMap, json['type']) ??
          OAuthLayoutType.iconText,
    );

const _$OAuthLayoutTypeEnumMap = {
  OAuthLayoutType.icon: 'icon',
  OAuthLayoutType.text: 'text',
  OAuthLayoutType.iconText: 'iconText',
};
