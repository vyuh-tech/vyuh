// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_in_dialog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenInDialogAction _$OpenInDialogActionFromJson(Map<String, dynamic> json) =>
    OpenInDialogAction(
      title: json['title'] as String?,
      behavior:
          $enumDecodeNullable(_$DialogBehaviorEnumMap, json['behavior']) ??
              DialogBehavior.modalBottomSheet,
      linkType: $enumDecodeNullable(_$LinkTypeEnumMap, json['linkType']) ??
          LinkType.url,
      url: json['url'] as String?,
      route: json['route'] == null
          ? null
          : ObjectReference.fromJson(json['route'] as Map<String, dynamic>),
      isAwaited: json['isAwaited'] as bool? ?? false,
    );

const _$DialogBehaviorEnumMap = {
  DialogBehavior.modalBottomSheet: 'modalBottomSheet',
  DialogBehavior.fullscreen: 'fullscreen',
};

const _$LinkTypeEnumMap = {
  LinkType.url: 'url',
  LinkType.route: 'route',
};
