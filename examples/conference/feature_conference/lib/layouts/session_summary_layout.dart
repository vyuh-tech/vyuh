import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

import '../content/session.dart';
import '../layouts/speaker_chip_layout.dart';
import '../layouts/track_chip_layout.dart';

part 'session_summary_layout.g.dart';

@JsonSerializable()
final class SessionSummaryLayout extends LayoutConfiguration<Session> {
  static const schemaName = '${Session.schemaName}.layout.summary';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Session Summary',
    fromJson: fromJson,
  );

  SessionSummaryLayout() : super(schemaType: schemaName);

  static SessionSummaryLayout fromJson(Map<String, dynamic> json) =>
      _$SessionSummaryLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Session content) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        final conferenceId =
            GoRouterState.of(context).pathParameters['conferenceId']!;
        final editionId =
            GoRouterState.of(context).pathParameters['editionId']!;

        vyuh.router.push(
            '/conferences/$conferenceId/editions/$editionId/sessions/${content.id}');
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content.title,
                style: theme.textTheme.titleMedium,
              ),
              if (content.speakers?.isNotEmpty ?? false)
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: content.speakers!
                      .map((speaker) =>
                          VyuhBinding.instance.content.buildContent(
                            context,
                            speaker,
                            layout: SpeakerChipLayout(mini: true),
                          ))
                      .toList(),
                ),
              if (content.tracks?.isNotEmpty ?? false)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: content.tracks!
                      .map((track) => VyuhBinding.instance.content.buildContent(
                            context,
                            track,
                            layout: TrackChipLayout(),
                          ))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
