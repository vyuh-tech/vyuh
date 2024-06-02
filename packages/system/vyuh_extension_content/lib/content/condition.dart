import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'condition.g.dart';

@JsonSerializable()
final class Condition {
  @JsonKey(fromJson: typeFromFirstOfListJson<ConditionConfiguration>)
  final ConditionConfiguration? configuration;

  Condition({this.configuration});

  Future<String?> execute(BuildContext context) async {
    return configuration?.execute(context);
  }

  factory Condition.fromJson(Map<String, dynamic> json) =>
      _$ConditionFromJson(json);
}

abstract class ConditionConfiguration implements SchemaItem {
  @override
  final String schemaType;

  final String? title;
  ConditionConfiguration({
    required this.schemaType,
    this.title,
  });

  Future<String?> execute(BuildContext context);
}
