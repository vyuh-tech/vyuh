import 'package:feature_conference/layouts/track_layout.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'track.g.dart';

@JsonSerializable()
class Track extends ContentItem {
  static const schemaName = 'conf.track';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: Track.fromJson,
    title: 'Track',
  );

  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayout: TrackLayout(),
    defaultLayoutDescriptor: TrackLayout.typeDescriptor,
  );

  @JsonKey(name: '_id')
  final String id;

  final String name;
  final ImageReference? icon;

  Track({
    required this.id,
    required this.name,
    this.icon,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
}
