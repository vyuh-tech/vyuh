import 'package:flutter/material.dart' as flutter;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'default_layout.g.dart';

enum MenuIconType {
  home,
  settings,
  category,
  account,
  menu;

  flutter.IconData get iconData => switch (this) {
        MenuIconType.home => flutter.Icons.home,
        MenuIconType.settings => flutter.Icons.settings,
        MenuIconType.category => flutter.Icons.category,
        MenuIconType.account => flutter.Icons.account_circle,
        MenuIconType.menu => flutter.Icons.menu,
      };
}

@JsonSerializable()
class MenuAction {
  // Define your fields here based on menuAction schema
  final String title;
  final MenuIconType icon;
  final Action? action;

  MenuAction({
    this.title = '',
    this.icon = MenuIconType.home,
    this.action,
  });

  factory MenuAction.fromJson(Map<String, dynamic> json) =>
      _$MenuActionFromJson(json);
}

@JsonSerializable()
class DefaultRouteLayout extends LayoutConfiguration<Route> {
  static const schemaName = '${Route.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Route Layout',
    fromJson: DefaultRouteLayout.fromJson,
  );

  final List<MenuAction>? actions;

  DefaultRouteLayout({this.actions}) : super(schemaType: schemaName);

  factory DefaultRouteLayout.fromJson(Map<String, dynamic> json) =>
      _$DefaultRouteLayoutFromJson(json);

  @override
  flutter.Widget build(flutter.BuildContext context, Route content) =>
      DefaultPageRouteLayout(content: content, layout: this);
}
