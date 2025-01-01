// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      title: json['title'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      capacity: (json['capacity'] as num).toInt(),
      floor: (json['floor'] as num?)?.toInt() ?? 1,
      facilities: (json['facilities'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$RoomFacilityEnumMap, e))
          .toList(),
    );

const _$RoomFacilityEnumMap = {
  RoomFacility.audio: 'audio',
  RoomFacility.projector: 'projector',
  RoomFacility.whiteboard: 'whiteboard',
  RoomFacility.wifi: 'wifi',
  RoomFacility.recording: 'recording',
  RoomFacility.streaming: 'streaming',
  RoomFacility.accessible: 'accessible',
  RoomFacility.power: 'power',
  RoomFacility.ac: 'ac',
};
