import 'dart:async';

import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'condition.g.dart';

@JsonSerializable()
final class Condition {
  @JsonKey(fromJson: typeFromFirstOfListJson<ConditionConfiguration>)
  final ConditionConfiguration? configuration;

  Condition({this.configuration});

  Future<String?> execute() async {
    return configuration?.execute();
  }

  factory Condition.fromJson(Map<String, dynamic> json) =>
      _$ConditionFromJson(json);
}

abstract class ConditionConfiguration {
  final String? title;
  final String schemaType;
  ConditionConfiguration({
    required this.schemaType,
    this.title,
  });

  Future<String?> execute();
}
