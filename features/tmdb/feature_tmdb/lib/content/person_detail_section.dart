import 'package:feature_tmdb/ui/person_details.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'person_detail_section.g.dart';

final class PersonDetailsSectionBuilder extends ContentBuilder {
  PersonDetailsSectionBuilder()
      : super(
          content: PersonDetailSection.typeDescriptor,
          defaultLayout: PersonDetailSectionLayout(),
          defaultLayoutDescriptor: PersonDetailSectionLayout.typeDescriptor,
        );
}

@JsonSerializable()
final class PersonDetailSectionLayout
    extends LayoutConfiguration<PersonDetailSection> {
  static const schemaName = '${PersonDetailSection.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'People Detail Section Layout',
    fromJson: PersonDetailSectionLayout.fromJson,
  );

  PersonDetailSectionLayout() : super(schemaType: schemaName);

  factory PersonDetailSectionLayout.fromJson(Map<String, dynamic> json) =>
      _$PersonDetailSectionLayoutFromJson(json);

  @override
  Widget build(BuildContext context, PersonDetailSection content) {
    switch (content.type) {
      case PersonDetailSectionType.hero:
        return const PersonHeroView();
      case PersonDetailSectionType.personalInfo:
        return const PersonStatisticsView();
      case PersonDetailSectionType.biography:
        return const PersonBiography();
      case PersonDetailSectionType.movieCredits:
        return const PersonMovieCredits();
      case PersonDetailSectionType.tvCredits:
        return const PersonTvSeriesCredits();
    }
  }
}

final class PersonWidget extends StatelessWidget {
  const PersonWidget({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(name);
  }
}

@JsonSerializable()
final class PersonDetailSection extends ContentItem {
  static const schemaName = 'tmdb.person.detailSection';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Person Detail Section',
    fromJson: PersonDetailSection.fromJson,
  );

  final PersonDetailSectionType type;

  PersonDetailSection({
    required this.type,
    super.layout,
  }) : super(schemaType: schemaName);

  factory PersonDetailSection.fromJson(Map<String, dynamic> json) =>
      _$PersonDetailSectionFromJson(json);
}

enum PersonDetailSectionType {
  hero,
  personalInfo,
  biography,
  movieCredits,
  tvCredits
}
