import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'snack_bar.g.dart';

@JsonSerializable()
final class ShowSnackBarAction extends ActionConfiguration {
  static const schemaName = 'vyuh.action.snackbar.show';
  static final typeDescriptor = TypeDescriptor(
    schemaType: ShowSnackBarAction.schemaName,
    title: 'Show Snack Bar',
    fromJson: ShowSnackBarAction.fromJson,
  );

  final bool allowClosing;
  final int showForSeconds;
  final SnackBarBehavior behavior;

  ShowSnackBarAction({
    super.title,
    this.allowClosing = false,
    this.showForSeconds = 3,
    this.behavior = SnackBarBehavior.fixed,
    super.isAwaited,
  }) : super(schemaType: schemaName);

  factory ShowSnackBarAction.fromJson(Map<String, dynamic> json) =>
      _$ShowSnackBarActionFromJson(json);

  @override
  FutureOr<void> execute(BuildContext context,
      {Map<String, dynamic>? arguments}) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      vyuh.log?.d('No ScaffoldMessenger found in the widget tree');
      return null;
    }

    final snackBar = SnackBar(
      content: Text(title ?? ''),
      showCloseIcon: allowClosing,
      duration: Duration(seconds: showForSeconds),
      behavior: behavior,
    );

    messenger.showSnackBar(snackBar);
  }
}

@JsonSerializable()
final class HideSnackBarAction extends ActionConfiguration {
  static const schemaName = 'vyuh.action.snackbar.hide';
  static final typeDescriptor = TypeDescriptor(
    schemaType: HideSnackBarAction.schemaName,
    title: 'Hide Snack Bar',
    fromJson: HideSnackBarAction.fromJson,
  );

  final bool immediately;

  HideSnackBarAction({
    super.title,
    this.immediately = false,
    super.isAwaited,
  }) : super(schemaType: schemaName);

  factory HideSnackBarAction.fromJson(Map<String, dynamic> json) =>
      _$HideSnackBarActionFromJson(json);

  @override
  FutureOr<void> execute(BuildContext context,
      {Map<String, dynamic>? arguments}) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      vyuh.log?.d('No ScaffoldMessenger found in the widget tree');
      return null;
    }

    if (immediately) {
      messenger.removeCurrentSnackBar();
    } else {
      messenger.hideCurrentSnackBar();
    }
  }
}
