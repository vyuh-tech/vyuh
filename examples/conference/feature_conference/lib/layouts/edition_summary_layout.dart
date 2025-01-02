import 'package:feature_conference/content/edition.dart';
import 'package:feature_conference/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

part 'edition_summary_layout.g.dart';

@JsonSerializable()
final class EditionSummaryLayout extends LayoutConfiguration<Edition> {
  static const schemaName = '${Edition.schemaName}.layout.summary';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: EditionSummaryLayout.fromJson,
    title: 'Edition Summary Layout',
  );

  EditionSummaryLayout() : super(schemaType: schemaName);

  @override
  Widget build(BuildContext context, Edition content) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        final conferenceId =
            GoRouterState.of(context).pathParameters['conferenceId']!;
        vyuh.router.go('/conference/$conferenceId/editions/${content.id}');
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              if (content.logo != null)
                ContentImage(
                  ref: content.logo,
                  height: 128,
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    content.title,
                    style: theme.textTheme.titleLarge,
                  ),
                  Text(
                    content.tagline,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              Row(
                spacing: 8,
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  Text(
                    '${dayFormat.format(content.startDate)} - ${dayFormat.format(content.endDate)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              if (content.venue != null)
                Row(
                  spacing: 8,
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    Text(
                      content.venue!.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  factory EditionSummaryLayout.fromJson(Map<String, dynamic> json) =>
      _$EditionSummaryLayoutFromJson(json);
}
