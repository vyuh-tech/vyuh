import 'package:feature_conference/layouts/conference_layout.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

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

  final String identifier;
  final String title;
  final ImageReference? icon;

  Conference({
    required this.id,
    required this.identifier,
    required this.title,
    this.icon,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Conference.fromJson(Map<String, dynamic> json) =>
      _$ConferenceFromJson(json);
}
