import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

import '../content/session.dart';
import '../content/speaker.dart';

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
    final theme = Theme.of(context);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(content.title),
            subtitle: Text(content.description),
            trailing: Text('${content.duration} min'),
          ),
          if (content.speakers != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  Text('Speakers',
                      style: Theme.of(context).textTheme.titleMedium),
                  ...content.speakers!.map((s) => _SpeakerWidget(s)),
                ],
              ),
            ),
          if (content.tracks != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Tracks',
                      style: Theme.of(context).textTheme.titleMedium),
                  Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    children: [
                      for (final track in content.tracks!)
                        Chip(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          label: Text(track.name),
                          labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimaryContainer),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SpeakerWidget extends StatelessWidget {
  final Speaker speaker;

  const _SpeakerWidget(this.speaker);

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        if (speaker.photo != null)
          ClipOval(
            child: ContentImage(
              ref: speaker.photo,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        Text(speaker.name),
      ],
    );
  }
}
