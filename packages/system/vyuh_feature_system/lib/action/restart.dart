import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'restart.g.dart';

@JsonSerializable()
final class RestartApplicationAction extends ActionConfiguration {
  static const schemaName = 'vyuh.action.restart';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: RestartApplicationAction.fromJson,
    title: 'Restart Application',
  );

  RestartApplicationAction({super.isAwaited}) : super(schemaType: schemaName);

  factory RestartApplicationAction.fromJson(Map<String, dynamic> json) =>
      _$RestartApplicationActionFromJson(json);

  @override
  FutureOr<void> execute(BuildContext context,
      {Map<String, dynamic>? arguments}) {
    return vyuh.tracker.init();
  }
}
