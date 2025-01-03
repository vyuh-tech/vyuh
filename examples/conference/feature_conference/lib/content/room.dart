import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

enum RoomFacility {
  audio,
  projector,
  whiteboard,
  wifi,
  recording,
  streaming,
  accessible,
  power,
  ac;

  String get displayName => switch (this) {
        RoomFacility.audio => 'Audio System',
        RoomFacility.projector => 'Video Projector',
        RoomFacility.whiteboard => 'Whiteboard',
        RoomFacility.wifi => 'Internet/WiFi',
        RoomFacility.recording => 'Video Recording',
        RoomFacility.streaming => 'Live Streaming',
        RoomFacility.accessible => 'Wheelchair Accessible',
        RoomFacility.power => 'Power Outlets',
        RoomFacility.ac => 'Air Conditioning',
      };
}

@JsonSerializable()
final class Room {
  final String title;
  final String slug;
  final String? description;
  final int capacity;
  final int floor;
  final List<RoomFacility>? facilities;

  Room({
    required this.title,
    required this.slug,
    this.description,
    this.capacity = 50,
    this.floor = 1,
    this.facilities,
  });

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}
