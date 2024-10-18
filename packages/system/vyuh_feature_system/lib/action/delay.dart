import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'delay.g.dart';

@JsonSerializable()
final class DelayAction extends ActionConfiguration {
  static const schemaName = 'vyuh.action.delay';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: DelayAction.fromJson,
    title: 'Delay',
  );

  final int milliseconds;
  final String message;

  DelayAction({this.milliseconds = 0, this.message = '', super.isAwaited})
      : super(schemaType: schemaName);

  factory DelayAction.fromJson(Map<String, dynamic> json) =>
      _$DelayActionFromJson(json);

  @override
  Future<FutureOr<void>> execute(BuildContext context,
      {Map<String, dynamic>? arguments}) async {
    if (isAwaited == true) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
        content:
            Text(message.isEmpty ? 'Waiting for $milliseconds ms' : message),
        duration: Duration(milliseconds: milliseconds),
      ));

      await Future.delayed(Duration(milliseconds: milliseconds));

      if (context.mounted) {
        ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
      }
    } else {
      Future.delayed(Duration(milliseconds: milliseconds));
    }
  }
}
