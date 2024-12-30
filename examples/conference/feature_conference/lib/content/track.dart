import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'edition.dart';

part 'track.g.dart';

@JsonSerializable()
class Track extends ContentItem {
  static const schemaName = 'conf.track';

  @JsonKey(name: '_id')
  final String id;

  final String name;
  final String description;
  final Edition edition;

  Track({
    required this.id,
    required this.name,
    required this.description,
    required this.edition,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
}
