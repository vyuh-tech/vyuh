import 'package:feature_conference/layouts/conference_layout.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/content/index.dart';

part 'conference.g.dart';

@JsonSerializable()
class Conference extends ContentItem {
  static const schemaName = 'conf.conference';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: Conference.fromJson,
    title: 'Conference',
  );

  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayout: ConferenceLayout(),
    defaultLayoutDescriptor: ConferenceLayout.typeDescriptor,
  );

  @JsonKey(name: '_id')
  final String id;

  final String title;
  final PortableTextContent? description;
  final String slug;
  final ImageReference? logo;

  Conference({
    required this.id,
    required this.title,
    this.description,
    required this.slug,
    this.logo,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Conference.fromJson(Map<String, dynamic> json) =>
      _$ConferenceFromJson(json);
}
