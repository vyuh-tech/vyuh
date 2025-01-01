import 'package:feature_conference/content/schedule.dart';
import 'package:feature_conference/content/sponsor.dart';
import 'package:feature_conference/content/venue.dart';
import 'package:feature_conference/layouts/edition_layout.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'edition.g.dart';

@JsonSerializable()
class EditionSponsor {
  final ObjectReference? sponsor;
  final SponsorLevel level;

  EditionSponsor({
    this.sponsor,
    this.level = SponsorLevel.bronze,
  });

  factory EditionSponsor.fromJson(Map<String, dynamic> json) =>
      _$EditionSponsorFromJson(json);
}

@JsonSerializable()
class Edition extends ContentItem {
  static const schemaName = 'conf.edition';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: Edition.fromJson,
    title: 'Edition',
  );

  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayout: EditionLayout(),
    defaultLayoutDescriptor: EditionLayout.typeDescriptor,
  );

  @JsonKey(name: '_id')
  final String id;

  final String slug;
  final String title;
  final String tagline;
  final DateTime startDate;
  final DateTime endDate;
  final String? url;
  final ObjectReference conference;
  final Venue? venue;
  final ImageReference? logo;
  final List<EditionSponsor>? sponsors;
  final List<ScheduleDay>? schedule;

  Edition({
    required this.id,
    required this.slug,
    required this.title,
    required this.tagline,
    required this.startDate,
    required this.endDate,
    required this.conference,
    required this.venue,
    this.sponsors,
    this.url,
    this.logo,
    required this.schedule,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Edition.fromJson(Map<String, dynamic> json) =>
      _$EditionFromJson(json);
}
