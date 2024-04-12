import 'dart:async';

import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'boolean.g.dart';

@JsonSerializable()
final class BooleanCondition extends ConditionConfiguration {
  static const schemaName = 'vyuh.condition.boolean';

  final bool value;

  final int evaluationDelayInSeconds;

  BooleanCondition({this.value = false, this.evaluationDelayInSeconds = 0})
      : super(schemaType: schemaName);

  factory BooleanCondition.fromJson(Map<String, dynamic> json) =>
      _$BooleanConditionFromJson(json);

  @override
  Future<String?> execute() async {
    if (evaluationDelayInSeconds > 0) {
      await Future.delayed(Duration(seconds: evaluationDelayInSeconds));
    }

    return value.toString();
  }
}
