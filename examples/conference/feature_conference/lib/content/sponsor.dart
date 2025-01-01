import 'package:feature_conference/layouts/sponsor_layout.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'sponsor.g.dart';

enum SponsorLevel { platinum, gold, silver, bronze }

@JsonSerializable()
class Sponsor extends ContentItem {
  static const schemaName = 'conf.sponsor';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: Sponsor.fromJson,
    title: 'Sponsor',
  );

  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayout: SponsorLayout(),
    defaultLayoutDescriptor: SponsorLayout.typeDescriptor,
  );

  @JsonKey(name: '_id')
  final String id;

  final String name;
  @JsonKey(name: 'slug.current')
  final String slug;
  final ImageReference? logo;
  final String? url;

  Sponsor({
    required this.id,
    required this.name,
    required this.slug,
    this.logo,
    this.url,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Sponsor.fromJson(Map<String, dynamic> json) =>
      _$SponsorFromJson(json);
}
