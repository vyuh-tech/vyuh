import 'package:feature_conference/layouts/session_layout.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/content/index.dart';

import '../content/speaker.dart';
import '../content/track.dart';

part 'session.g.dart';

enum SessionFormat {
  intro,
  keynote,
  talk,
  workshop,
  panel,
  lightning,
  breakout,
  networking,
  outro,
}

enum SessionLevel {
  beginner,
  intermediate,
  advanced,
  all,
}

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

  static final descriptor = ContentDescriptor.createDefault(
    schemaType: schemaName,
    title: 'Session',
  );

  @JsonKey(name: '_id')
  final String id;

  final String title;
  final String? slug;
  final PortableTextContent? description;
  final int duration;
  final SessionFormat format;
  final SessionLevel level;
  final ObjectReference? edition;

  final List<Speaker>? speakers;

  final List<Track>? tracks;

  Session({
    required this.id,
    required this.title,
    this.slug,
    this.description,
    required this.duration,
    this.format = SessionFormat.talk,
    this.level = SessionLevel.all,
    this.edition,
    this.speakers,
    this.tracks,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
