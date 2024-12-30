import 'package:feature_conference/layouts/speaker_layout.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'speaker.g.dart';

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
  final String bio;
  final ImageReference? photo;

  Speaker({
    required this.id,
    required this.name,
    required this.bio,
    this.photo,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Speaker.fromJson(Map<String, dynamic> json) =>
      _$SpeakerFromJson(json);
}
