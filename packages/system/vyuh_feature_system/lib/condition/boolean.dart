import 'dart:async';

import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'boolean.g.dart';

@JsonSerializable()
final class BooleanCondition extends ConditionConfiguration {
  static const schemaName = 'vyuh.condition.boolean';

  @JsonKey(defaultValue: false)
  final bool value;

  BooleanCondition({this.value = false}) : super(schemaType: schemaName);

  factory BooleanCondition.fromJson(Map<String, dynamic> json) =>
      _$BooleanConditionFromJson(json);

  @override
  Future<String?> execute() async {
    return value.toString();
  }
}
