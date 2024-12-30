import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'speaker.g.dart';

@JsonSerializable()
class Speaker extends ContentItem {
  static const schemaName = 'conf.speaker';

  @JsonKey(name: '_id')
  final String id;

  final String name;
  final String bio;
  final String? photoUrl;

  Speaker({
    required this.id,
    required this.name,
    required this.bio,
    this.photoUrl,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Speaker.fromJson(Map<String, dynamic> json) =>
      _$SpeakerFromJson(json);
}
