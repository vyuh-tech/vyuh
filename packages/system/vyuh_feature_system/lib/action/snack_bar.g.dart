// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snack_bar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowSnackBarAction _$ShowSnackBarActionFromJson(Map<String, dynamic> json) =>
    ShowSnackBarAction(
      title: json['title'] as String?,
      allowClosing: json['allowClosing'] as bool? ?? false,
      showForSeconds: (json['showForSeconds'] as num?)?.toInt() ?? 3,
      behavior:
          $enumDecodeNullable(_$SnackBarBehaviorEnumMap, json['behavior']) ??
              SnackBarBehavior.fixed,
      isAwaited: json['isAwaited'] as bool? ?? false,
    );

const _$SnackBarBehaviorEnumMap = {
  SnackBarBehavior.fixed: 'fixed',
  SnackBarBehavior.floating: 'floating',
};

HideSnackBarAction _$HideSnackBarActionFromJson(Map<String, dynamic> json) =>
    HideSnackBarAction(
      title: json['title'] as String?,
      immediately: json['immediately'] as bool? ?? false,
      isAwaited: json['isAwaited'] as bool? ?? false,
    );
