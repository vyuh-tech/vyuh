import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'part_of_day.g.dart';

@JsonSerializable()
final class PartOfDayCondition extends ConditionConfiguration {
  static const schemaName = 'misc.condition.partOfDay';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: PartOfDayCondition.fromJson,
    title: 'Part of Day',
  );

  PartOfDayCondition() : super(schemaType: schemaName, title: 'Part of Day');

  factory PartOfDayCondition.fromJson(Map<String, dynamic> json) =>
      _$PartOfDayConditionFromJson(json);

  @override
  Future<String?> execute(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour < 12) {
      // 5AM - 12PM
      return Future.value('morning');
    } else if (hour < 17) {
      // 12PM - 5PM
      return Future.value('afternoon');
    } else if (hour < 21) {
      // 5PM - 9PM
      return Future.value('evening');
    } else {
      // 9PM - 5AM
      return Future.value('night');
    }
  }
}
