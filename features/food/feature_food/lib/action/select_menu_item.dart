import 'dart:async';

import 'package:feature_food/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as go;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'select_menu_item.g.dart';

@JsonSerializable()
final class SelectMenuItem extends ActionConfiguration {
  static const schemaName = 'food.action.selectItem';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: SelectMenuItem.fromJson,
    title: 'Select Menu Item',
  );

  final ObjectReference? menuItem;

  SelectMenuItem({this.menuItem, super.isAwaited})
      : super(schemaType: schemaName);

  factory SelectMenuItem.fromJson(Map<String, dynamic> json) =>
      _$SelectMenuItemFromJson(json);

  @override
  FutureOr<void> execute(
    BuildContext context, {
    Map<String, dynamic>? arguments,
  }) {
    if (menuItem != null) {
      context.push('${FoodPath.menuItem}?id=${menuItem!.ref}');
    }
  }
}
