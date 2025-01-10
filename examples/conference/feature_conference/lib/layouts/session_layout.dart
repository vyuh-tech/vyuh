import 'package:feature_conference/layouts/speaker_chip_layout.dart';
import 'package:feature_conference/layouts/track_chip_layout.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

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
    return Column(
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
          style: Theme.of(context).textTheme.headlineSmall,
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
    return content.description != null
        ? vyuh.content.buildContent(context, content.description!)
        : const SizedBox.shrink();
  }
}

class _SpeakersList extends StatelessWidget {
  final List<Speaker> speakers;

  const _SpeakersList({required this.speakers});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Speakers',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: speakers
              .map((speaker) => vyuh.content.buildContent(
                    context,
                    speaker,
                    layout: SpeakerChipLayout(),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _TracksList extends StatelessWidget {
  final List<Track> tracks;

  const _TracksList({required this.tracks});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tracks',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tracks
              .map((track) => vyuh.content.buildContent(
                    context,
                    track,
                    layout: TrackChipLayout(),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
