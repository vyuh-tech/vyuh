import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

import '../content/edition.dart';
import '../content/speaker.dart';
import '../content/track.dart';

part 'session.g.dart';

@JsonSerializable()
class Session extends ContentItem {
  static const schemaName = 'conf.session';

  @JsonKey(name: '_id')
  final String id;

  final String title;
  final String description;
  final int duration;
  final Edition edition;
  final List<Speaker> speakers;
  final List<Track> tracks;

  Session({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.edition,
    required this.speakers,
    required this.tracks,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
