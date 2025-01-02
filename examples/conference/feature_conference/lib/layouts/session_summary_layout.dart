import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

import '../content/session.dart';
import '../content/speaker.dart';
import '../content/track.dart';

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

    return Card(
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
            if (content.speakers?.isNotEmpty ?? false) ...[
              _SpeakersList(speakers: content.speakers!),
            ],
            if (content.tracks?.isNotEmpty ?? false)
              _TracksList(tracks: content.tracks!),
          ],
        ),
      ),
    );
  }
}

class _SpeakersList extends StatelessWidget {
  final List<Speaker> speakers;

  const _SpeakersList({required this.speakers});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children:
          speakers.map((speaker) => _SpeakerChip(speaker: speaker)).toList(),
    );
  }
}

class _SpeakerChip extends StatelessWidget {
  final Speaker speaker;

  const _SpeakerChip({required this.speaker});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        final editionId =
            GoRouterState.of(context).pathParameters['editionId']!;
        final conferenceId =
            GoRouterState.of(context).pathParameters['conferenceId']!;

        vyuh.router.push(
            '/conference/$conferenceId/editions/$editionId/speakers/${speaker.id}');
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (speaker.photo != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ClipOval(
                child: ContentImage(
                  ref: speaker.photo,
                  width: 32,
                  height: 32,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.person,
                  size: 32, color: theme.colorScheme.secondary),
            ),
          Text(speaker.name),
        ],
      ),
    );
  }
}

class _TracksList extends StatelessWidget {
  final List<Track> tracks;

  const _TracksList({required this.tracks});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tracks.map((track) => _TrackChip(track: track)).toList(),
    );
  }
}

class _TrackChip extends StatelessWidget {
  final Track track;

  const _TrackChip({required this.track});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        final editionId =
            GoRouterState.of(context).pathParameters['editionId']!;
        final conferenceId =
            GoRouterState.of(context).pathParameters['conferenceId']!;

        vyuh.router.push(
            '/conference/$conferenceId/editions/$editionId/tracks/${track.id}');
      },
      child: Chip(
        visualDensity: VisualDensity.compact,
        backgroundColor: theme.colorScheme.surfaceDim,
        side: BorderSide.none,
        label: Text(track.title),
        padding: EdgeInsets.zero,
        labelStyle: TextStyle(color: theme.colorScheme.onSurface),
      ),
    );
  }
}
