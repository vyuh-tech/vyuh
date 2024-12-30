import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'conference.g.dart';

@JsonSerializable()
class Conference extends ContentItem {
  static const schemaName = 'conf.conference';

  @JsonKey(name: '_id')
  final String id;

  final String identifier;
  final String title;
  final String? iconUrl;

  Conference({
    required this.id,
    required this.identifier,
    required this.title,
    this.iconUrl,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Conference.fromJson(Map<String, dynamic> json) =>
      _$ConferenceFromJson(json);
}
