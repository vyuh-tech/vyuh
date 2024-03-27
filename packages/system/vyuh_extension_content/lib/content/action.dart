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

  FutureOr<void> execute(BuildContext context) async {
    for (final config in configurations ?? []) {
      await config.execute(context);
    }
  }

  Action({this.title, this.configurations});

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  bool get isEmpty => configurations?.isEmpty ?? true;
  bool get isNotEmpty => !isEmpty;
}

abstract class ActionConfiguration {
  final String? title;
  final String schemaType;

  ActionConfiguration({
    required this.schemaType,
    this.title,
  });

  FutureOr<void> execute(BuildContext context);
}
