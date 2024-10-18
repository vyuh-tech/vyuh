// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowAlertAction _$ShowAlertActionFromJson(Map<String, dynamic> json) =>
    ShowAlertAction(
      title: json['title'] as String?,
      message: json['message'] as String? ?? '',
      actions: (json['actions'] as List<dynamic>?)
              ?.map((e) => UserAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      barrierDismissible: json['barrierDismissible'] as bool? ?? true,
      isAwaited: json['isAwaited'] as bool? ?? false,
    );

UserAction _$UserActionFromJson(Map<String, dynamic> json) => UserAction(
      action: json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
      title: json['title'] as String? ?? 'Title',
    );
