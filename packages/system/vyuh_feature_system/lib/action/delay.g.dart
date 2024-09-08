// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delay.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DelayAction _$DelayActionFromJson(Map<String, dynamic> json) => DelayAction(
      milliseconds: (json['milliseconds'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      isAwaited: json['isAwaited'] as bool? ?? false,
    );
