import 'package:feature_conference/layouts/session_layout.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

import '../content/speaker.dart';
import '../content/track.dart';

part 'session.g.dart';

@JsonSerializable()
class Session extends ContentItem {
  static const schemaName = 'conf.session';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: Session.fromJson,
    title: 'Session',
  );

  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayout: SessionLayout(),
    defaultLayoutDescriptor: SessionLayout.typeDescriptor,
  );

  @JsonKey(name: '_id')
  final String id;

  final String title;
  final String description;
  final int duration;
  final ObjectReference? edition;

  @JsonKey(fromJson: speakerList)
  final List<Speaker>? speakers;

  final List<Track>? tracks;

  static List<Speaker>? speakerList(dynamic json) {
    final speakers = json is List ? json : null;
    if (speakers == null) {
      return null;
    }

    return speakers.nonNulls
        .cast<Map<String, dynamic>>()
        .map((e) => Speaker.fromJson(e))
        .toList();
  }

  Session({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    this.edition,
    this.speakers,
    this.tracks,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
