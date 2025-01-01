// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleDay _$ScheduleDayFromJson(Map<String, dynamic> json) => ScheduleDay(
      startTime: DateTime.parse(json['startTime'] as String),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

ScheduleItem _$ScheduleItemFromJson(Map<String, dynamic> json) => ScheduleItem(
      session: json['session'] == null
          ? null
          : ObjectReference.fromJson(json['session'] as Map<String, dynamic>),
      breakPeriod: json['breakPeriod'] == null
          ? null
          : ScheduleBreak.fromJson(json['breakPeriod'] as Map<String, dynamic>),
    );

ScheduleBreak _$ScheduleBreakFromJson(Map<String, dynamic> json) =>
    ScheduleBreak(
      title: json['title'] as String,
      description: json['description'] as String?,
    );
