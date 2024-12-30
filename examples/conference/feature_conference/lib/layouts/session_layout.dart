import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

import '../content/session.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Speakers:',
                      style: Theme.of(context).textTheme.titleMedium),
                  ...content.speakers!.map((s) => Text(s.name)),
                ],
              ),
            ),
          if (content.tracks != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tracks:',
                      style: Theme.of(context).textTheme.titleMedium),
                  ...content.tracks!.map((t) => Text(t.name)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
