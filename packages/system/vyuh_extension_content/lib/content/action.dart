import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'action.g.dart';

@JsonSerializable()
final class Action {
  @JsonKey(fromJson: typeFromFirstOfListJson<ActionConfiguration>)
  final ActionConfiguration? configuration;

  FutureOr<void> execute(BuildContext context) {
    configuration?.execute(context);
  }

  Action({this.configuration});

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);
}

abstract class ActionConfiguration {
  final String? title;
  final String schemaType;
  final bool isAsync;

  ActionConfiguration({
    required this.schemaType,
    this.isAsync = false,
    this.title,
  });

  FutureOr<void> execute(BuildContext context);
}
