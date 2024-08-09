// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoPlayerItem _$VideoPlayerItemFromJson(Map<String, dynamic> json) =>
    VideoPlayerItem(
      title: json['title'] as String?,
      url: json['url'] as String,
      loop: json['loop'] as bool? ?? false,
      autoplay: json['autoplay'] as bool? ?? false,
      muted: json['muted'] as bool? ?? false,
    );

VideoPlayerDefaultLayout _$VideoPlayerDefaultLayoutFromJson(
        Map<String, dynamic> json) =>
    VideoPlayerDefaultLayout();
