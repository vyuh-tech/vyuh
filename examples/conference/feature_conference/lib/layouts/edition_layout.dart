import 'package:feature_conference/content/sponsor.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

import '../content/edition.dart';
import '../utils.dart';

part 'edition_layout.g.dart';

extension on SponsorLevel {
  Color get color {
    return switch (this) {
      SponsorLevel.platinum => Colors.black,
      SponsorLevel.gold => Colors.amber,
      SponsorLevel.silver => Colors.grey.shade400,
      SponsorLevel.bronze => Colors.brown.shade300,
    };
  }
}

@JsonSerializable()
final class EditionLayout extends LayoutConfiguration<Edition> {
  static const schemaName = '${Edition.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: EditionLayout.fromJson,
    title: 'Edition Layout',
  );

  EditionLayout() : super(schemaType: schemaName);

  factory EditionLayout.fromJson(Map<String, dynamic> json) =>
      _$EditionLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Edition content) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        if (content.logo != null)
          ContentImage(
            ref: content.logo,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(content.title),
          titleTextStyle: theme.textTheme.headlineSmall,
          subtitle: Text(content.tagline),
        ),
        Row(
          spacing: 8,
          children: [
            const Icon(Icons.event),
            Text(
                '${dayFormat.format(content.startDate.toLocal())} - ${dayFormat.format(content.endDate.toLocal())}'),
          ],
        ),
        if (content.url != null)
          Row(
            spacing: 8,
            children: [
              const Icon(Icons.link),
              Expanded(child: Text(content.url!)),
            ],
          ),
        if (content.venue != null) ...[
          Text('Venue', style: theme.textTheme.titleLarge),
          vyuh.content.buildContent(context, content.venue!),
        ],
        if (content.sponsors?.isNotEmpty ?? false) ...[
          Text('Sponsors', style: theme.textTheme.titleLarge),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: content.sponsors!.length,
            itemBuilder: (context, index) {
              final sponsor = content.sponsors![index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      vyuh.content.buildContent(context, sponsor.sponsor!),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 4,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: sponsor.level.color,
                          ),
                          Text(
                            sponsor.level.name.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
