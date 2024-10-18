import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'action.g.dart';

@JsonSerializable()
final class Action {
  final String? title;

  @JsonKey(fromJson: Action.configurationList)
  final List<ActionConfiguration>? configurations;

  static configurationList(dynamic json) =>
      listFromJson<ActionConfiguration>(json);

  FutureOr<void> execute(BuildContext context,
      {Map<String, dynamic>? arguments}) async {
    for (final config in configurations ?? []) {
      if (config.isAwaited) {
        await config.execute(context, arguments: arguments);
      } else {
        unawaited(config.execute(context, arguments: arguments));
      }
    }
  }

  Action({this.title, this.configurations});

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  bool get isEmpty => configurations?.isEmpty ?? true;
  bool get isNotEmpty => !isEmpty;
}

abstract class ActionConfiguration implements SchemaItem {
  @override
  final String schemaType;

  final String? title;

  @JsonKey(defaultValue: false)
  final bool? isAwaited;

  ActionConfiguration({
    required this.schemaType,
    this.title,
    required this.isAwaited,
  });

  FutureOr<void> execute(BuildContext context,
      {Map<String, dynamic>? arguments});
}
