// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      title: json['title'] as String,
      tabs: (json['tabs'] as List<dynamic>?)
              ?.map((e) => TabInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

TabInfo _$TabInfoFromJson(Map<String, dynamic> json) => TabInfo(
      title: json['title'] as String,
      path: json['path'] as String,
      iconIdentifier: $enumDecodeNullable(
              _$IconIdentifierEnumMap, json['iconIdentifier']) ??
          IconIdentifier.home,
    );

const _$IconIdentifierEnumMap = {
  IconIdentifier.home: 'home',
  IconIdentifier.settings: 'settings',
  IconIdentifier.categories: 'categories',
  IconIdentifier.account: 'account',
  IconIdentifier.menu: 'menu',
  IconIdentifier.search: 'search',
  IconIdentifier.messages: 'messages',
  IconIdentifier.notifications: 'notifications',
  IconIdentifier.cart: 'cart',
  IconIdentifier.plus: 'plus',
  IconIdentifier.movies: 'movies',
  IconIdentifier.series: 'series',
  IconIdentifier.food: 'food',
  IconIdentifier.watchlist: 'watchlist',
};
