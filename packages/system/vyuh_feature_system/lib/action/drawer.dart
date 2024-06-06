import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'drawer.g.dart';

enum DrawerActionType { open, close }

@JsonSerializable()
final class DrawerAction extends ActionConfiguration {
  static const schemaName = 'vyuh.action.drawer';
  static final typeDescriptor = TypeDescriptor(
    schemaType: DrawerAction.schemaName,
    title: 'Open / Close Drawer',
    fromJson: DrawerAction.fromJson,
  );

  final DrawerActionType actionType;
  final bool isEndDrawer;

  DrawerAction({
    super.title,
    this.actionType = DrawerActionType.open,
    this.isEndDrawer = false,
  }) : super(schemaType: schemaName);

  factory DrawerAction.fromJson(Map<String, dynamic> json) =>
      _$DrawerActionFromJson(json);

  @override
  FutureOr<void> execute(BuildContext context,
      {Map<String, dynamic>? arguments}) {
    final scaffoldState = Scaffold.maybeOf(context);
    if (scaffoldState == null) {
      vyuh.log?.d('DrawerAction requires a Scaffold ancestor');
      return null;
    }

    if (isEndDrawer == false && scaffoldState.hasDrawer == false) {
      vyuh.log
          ?.d('DrawerAction requires an drawer to be present in your Scaffold');
      return null;
    }

    if (isEndDrawer && scaffoldState.hasEndDrawer == false) {
      vyuh.log?.d(
          'DrawerAction requires an endDrawer to be present in your Scaffold');
      return null;
    }

    switch (actionType) {
      case DrawerActionType.open:
        if (isEndDrawer) {
          scaffoldState.openEndDrawer();
        } else {
          scaffoldState.openDrawer();
        }
        break;
      case DrawerActionType.close:
        if (isEndDrawer) {
          scaffoldState.openEndDrawer();
        } else {
          scaffoldState.openDrawer();
        }
        break;
    }
  }
}
