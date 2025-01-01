import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

import '../layouts/speaker_layout.dart';

part 'speaker.g.dart';

@JsonSerializable()
class SpeakerSocial {
  final String? twitter;
  final String? github;
  final String? linkedin;
  final String? website;

  SpeakerSocial({
    this.twitter,
    this.github,
    this.linkedin,
    this.website,
  });

  factory SpeakerSocial.fromJson(Map<String, dynamic> json) =>
      _$SpeakerSocialFromJson(json);

  String? get twitterUrl => twitter != null ? 'https://twitter.com/$twitter' : null;
  String? get githubUrl => github != null ? 'https://github.com/$github' : null;
  String? get linkedinUrl => linkedin != null ? 'https://linkedin.com/in/$linkedin' : null;
}

@JsonSerializable()
class Speaker extends ContentItem {
  static const schemaName = 'conf.speaker';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: Speaker.fromJson,
    title: 'Speaker',
  );

  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayout: SpeakerLayout(),
    defaultLayoutDescriptor: SpeakerLayout.typeDescriptor,
  );

  @JsonKey(name: '_id')
  final String id;

  final String name;
  final String? tagline;
  final String? bio;
  final ImageReference? photo;
  final SpeakerSocial? social;

  Speaker({
    required this.id,
    required this.name,
    this.tagline,
    this.bio,
    this.photo,
    this.social,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Speaker.fromJson(Map<String, dynamic> json) => _$SpeakerFromJson(json);
}
