import 'dart:async';

import 'package:flutter/material.dart' as f;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'alert.g.dart';

@JsonSerializable()
final class ShowAlertAction extends ActionConfiguration {
  static const schemaName = 'vyuh.action.alert';
  static final typeDescriptor = TypeDescriptor(
    schemaType: ShowAlertAction.schemaName,
    title: 'Show Alert',
    fromJson: ShowAlertAction.fromJson,
  );

  final String message;
  final List<UserAction> actions;
  final bool barrierDismissible;

  ShowAlertAction({
    super.title,
    this.message = '',
    this.actions = const [],
    this.barrierDismissible = true,
    required super.isAwaited,
  }) : super(schemaType: schemaName);

  factory ShowAlertAction.fromJson(Map<String, dynamic> json) =>
      _$ShowAlertActionFromJson(json);

  @override
  FutureOr<void> execute(f.BuildContext context,
      {Map<String, dynamic>? arguments}) {
    return f.showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return f.AlertDialog(
            icon: const f.Icon(f.Icons.warning_amber_rounded),
            title: f.Text(title ?? ''),
            content: f.Text(message),
            actions: [
              for (final action in actions)
                f.ElevatedButton(
                  onPressed: () {
                    action.action?.execute(context);
                  },
                  child: f.Text(action.title),
                ),
            ],
          );
        });
  }
}

@JsonSerializable()
final class UserAction {
  final Action? action;
  final String title;

  UserAction({this.action, this.title = 'Title'});

  factory UserAction.fromJson(Map<String, dynamic> json) =>
      _$UserActionFromJson(json);
}
