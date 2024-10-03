// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoPlayerItem _$VideoPlayerItemFromJson(Map<String, dynamic> json) =>
    VideoPlayerItem(
      title: json['title'] as String?,
      linkType: $enumDecode(_$VideoLinkTypeEnumMap, json['linkType']),
      url: json['url'] as String?,
      file: json['file'] == null
          ? null
          : FileReference.fromJson(json['file'] as Map<String, dynamic>),
      loop: json['loop'] as bool? ?? false,
      autoplay: json['autoplay'] as bool? ?? false,
      muted: json['muted'] as bool? ?? false,
      layout: typeFromFirstOfListJson(json['layout']),
    );

const _$VideoLinkTypeEnumMap = {
  VideoLinkType.url: 'url',
  VideoLinkType.file: 'file',
};

VideoPlayerDefaultLayout _$VideoPlayerDefaultLayoutFromJson(
        Map<String, dynamic> json) =>
    VideoPlayerDefaultLayout();
