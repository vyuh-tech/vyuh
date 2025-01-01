import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

import '../content/session.dart';
import '../content/speaker.dart';
import '../content/track.dart';

part 'session_layout.g.dart';

@JsonSerializable()
final class SessionLayout extends LayoutConfiguration<Session> {
  static const schemaName = '${Session.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: SessionLayout.fromJson,
    title: 'Session Layout',
  );

  SessionLayout() : super(schemaType: schemaName);

  factory SessionLayout.fromJson(Map<String, dynamic> json) =>
      _$SessionLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Session content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SessionHeader(content: content),
            _SessionDetails(content: content),
            if (content.speakers?.isNotEmpty ?? false)
              _SpeakersList(speakers: content.speakers!),
            if (content.tracks?.isNotEmpty ?? false)
              _TracksList(tracks: content.tracks!),
          ],
        ),
      ),
    );
  }
}

class _SessionHeader extends StatelessWidget {
  final Session content;

  const _SessionHeader({required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Row(
          spacing: 16,
          children: [
            Row(
              spacing: 4,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                Text('${content.duration} minutes'),
              ],
            ),
            Chip(
              avatar: Icon(
                Icons.format_list_bulleted,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              label: Text(content.format.name),
            ),
          ],
        ),
      ],
    );
  }
}

class _SessionDetails extends StatelessWidget {
  final Session content;

  const _SessionDetails({required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(content.description);
  }
}

class _SpeakersList extends StatelessWidget {
  final List<Speaker> speakers;

  const _SpeakersList({required this.speakers});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Speakers',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: speakers
              .map((speaker) => _SpeakerChip(speaker: speaker))
              .toList(),
        ),
      ],
    );
  }
}

class _SpeakerChip extends StatelessWidget {
  final Speaker speaker;

  const _SpeakerChip({required this.speaker});

  @override
  Widget build(BuildContext context) {
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
        spacing: 4,
        children: [
          speaker.photo != null
              ? ClipOval(
                  child: ContentImage(
                    ref: speaker.photo,
                    width: 48,
                    height: 48,
                  ),
                )
              : ClipOval(
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Text(
                      speaker.name[0],
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
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
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tracks',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tracks.map((track) => _TrackChip(track: track)).toList(),
        ),
      ],
    );
  }
}

class _TrackChip extends StatelessWidget {
  final Track track;

  const _TrackChip({required this.track});

  @override
  Widget build(BuildContext context) {
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
        avatar: const Icon(Icons.view_column),
        label: Text(track.title),
      ),
    );
  }
}
