// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavigationAction _$NavigationActionFromJson(Map<String, dynamic> json) =>
    NavigationAction(
      navigationType: $enumDecodeNullable(
              _$NavigationTypeEnumMap, json['navigationType']) ??
          NavigationType.push,
      linkType: $enumDecodeNullable(_$LinkTypeEnumMap, json['linkType']) ??
          LinkType.url,
      route: json['route'] == null
          ? null
          : ObjectReference.fromJson(json['route'] as Map<String, dynamic>),
      url: json['url'] as String?,
      title: json['title'] as String?,
    );

const _$NavigationTypeEnumMap = {
  NavigationType.go: 'go',
  NavigationType.push: 'push',
};

const _$LinkTypeEnumMap = {
  LinkType.url: 'url',
  LinkType.route: 'route',
};
