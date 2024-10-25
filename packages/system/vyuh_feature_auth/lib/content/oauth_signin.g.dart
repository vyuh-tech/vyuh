// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oauth_signin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuthSignIn _$OAuthSignInFromJson(Map<String, dynamic> json) => OAuthSignIn(
      authTypes: (json['authTypes'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$OAuthTypeEnumMap, e))
              .toList() ??
          const [],
      showLoginError: json['showLoginError'] as bool? ?? true,
      action: json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
      layout: typeFromFirstOfListJson(json['layout']),
    );

const _$OAuthTypeEnumMap = {
  OAuthType.google: 'google',
  OAuthType.apple: 'apple',
  OAuthType.meta: 'meta',
  OAuthType.github: 'github',
  OAuthType.twitter: 'twitter',
  OAuthType.linkedin: 'linkedin',
  OAuthType.microsoft: 'microsoft',
  OAuthType.custom: 'custom',
};
