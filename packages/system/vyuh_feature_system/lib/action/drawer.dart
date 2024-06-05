import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'drawer.g.dart';

enum DrawerActionType { open, close }

@JsonSerializable()
final class DrawerAction extends ActionConfiguration {
  final DrawerActionType type;
  final bool isEndDrawer;

  DrawerAction({super.title, required this.type, this.isEndDrawer = false})
      : super(schemaType: 'vyuh.action.drawer');

  factory DrawerAction.fromJson(Map<String, dynamic> json) =>
      _$DrawerActionFromJson(json);

  @override
  FutureOr<void> execute(BuildContext context,
      {Map<String, dynamic>? arguments}) {}
}
