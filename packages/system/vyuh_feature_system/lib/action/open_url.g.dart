// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_url.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenUrlAction _$OpenUrlActionFromJson(Map<String, dynamic> json) =>
    OpenUrlAction(
      title: json['title'] as String?,
      url: json['url'] as String?,
      mode: $enumDecodeNullable(_$UrlLaunchModeEnumMap, json['mode']) ??
          UrlLaunchMode.platformDefault,
    );

const _$UrlLaunchModeEnumMap = {
  UrlLaunchMode.inApp: 'inApp',
  UrlLaunchMode.externalApp: 'externalApp',
  UrlLaunchMode.platformDefault: 'platformDefault',
};
