import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'settings.g.dart';

@JsonSerializable()
class Settings {
  static const schemaName = 'common.settings';

  final String title;

  @JsonKey(defaultValue: [])
  final List<TabInfo> tabs;
  Settings({
    required this.title,
    required this.tabs,
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
}

extension FetchSettingsByProvider on Settings {
  static Future<Settings?> fetchByProvider(
      {required String identifier, required String documentId}) async {
    final settings = await (vyuh.content.provider.name
            .toLowerCase()
            .contains('localsanity')
        ? vyuh.content.provider
            .fetchById(documentId, fromJson: Settings.fromJson)
        : vyuh.content.provider.fetchSingle(
            '*[_type == "${Settings.schemaName}" && identifier == "$identifier"][0]',
            fromJson: Settings.fromJson));

    return settings;
  }
}

enum IconIdentifier {
  home,
  settings,
  categories,
  account,
  menu,
  search,
  messages,
  notifications,
  cart,
  plus,
  movies,
  series,
  food,
  watchlist
}

@JsonSerializable()
class TabInfo {
  final String title;
  final String path;

  @JsonKey(defaultValue: IconIdentifier.home)
  final IconIdentifier iconIdentifier;

  static const _icons = {
    IconIdentifier.home: Icons.home_outlined,
    IconIdentifier.settings: Icons.settings,
    IconIdentifier.categories: Icons.category,
    IconIdentifier.account: Icons.account_box,
    IconIdentifier.menu: Icons.menu,
    IconIdentifier.search: Icons.explore_outlined,
    IconIdentifier.messages: Icons.message,
    IconIdentifier.notifications: Icons.notifications,
    IconIdentifier.cart: Icons.shopping_cart,
    IconIdentifier.plus: Icons.add,
    IconIdentifier.movies: Icons.movie_outlined,
    IconIdentifier.series: Icons.tv_outlined,
    IconIdentifier.food: Icons.fastfood_outlined,
    IconIdentifier.watchlist: Icons.subscriptions_outlined,
  };

  static const _filledIcons = {
    IconIdentifier.home: Icons.home,
    IconIdentifier.settings: Icons.settings,
    IconIdentifier.categories: Icons.category,
    IconIdentifier.account: Icons.account_box,
    IconIdentifier.menu: Icons.menu,
    IconIdentifier.search: Icons.explore_rounded,
    IconIdentifier.messages: Icons.message,
    IconIdentifier.notifications: Icons.notifications,
    IconIdentifier.cart: Icons.shopping_cart,
    IconIdentifier.plus: Icons.add,
    IconIdentifier.movies: Icons.movie_outlined,
    IconIdentifier.series: Icons.tv_outlined,
    IconIdentifier.food: Icons.fastfood_outlined,
    IconIdentifier.watchlist: Icons.subscriptions_rounded,
  };

  final key = GlobalKey<NavigatorState>();
  Icon get icon => Icon(_icons[iconIdentifier]!);
  Icon get selectedIcon => Icon(_filledIcons[iconIdentifier]!);

  TabInfo({
    required this.title,
    required this.path,
    required this.iconIdentifier,
  });

  factory TabInfo.fromJson(Map<String, dynamic> json) =>
      _$TabInfoFromJson(json);
}
