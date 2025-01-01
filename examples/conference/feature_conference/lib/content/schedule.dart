import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/plugin/content/reference.dart';

part 'schedule.g.dart';

@JsonSerializable()
final class ScheduleDay {
  final DateTime startTime;
  final List<ScheduleItem>? items;

  ScheduleDay({
    required this.startTime,
    this.items,
  });

  factory ScheduleDay.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDayFromJson(json);
}

@JsonSerializable()
final class ScheduleItem {
  final ObjectReference? session;
  final ScheduleBreak? breakPeriod;

  ScheduleItem({
    this.session,
    this.breakPeriod,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) =>
      _$ScheduleItemFromJson(json);
}

@JsonSerializable()
final class ScheduleBreak {
  final String title;
  final String? description;

  ScheduleBreak({
    required this.title,
    this.description,
  });

  factory ScheduleBreak.fromJson(Map<String, dynamic> json) =>
      _$ScheduleBreakFromJson(json);
}
