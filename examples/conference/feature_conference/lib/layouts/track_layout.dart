import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/ui/content_image.dart';

import '../content/track.dart';

part 'track_layout.g.dart';

@JsonSerializable()
final class TrackLayout extends LayoutConfiguration<Track> {
  static const schemaName = '${Track.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: TrackLayout.fromJson,
    title: 'Track Layout',
  );

  TrackLayout() : super(schemaType: schemaName);

  factory TrackLayout.fromJson(Map<String, dynamic> json) =>
      _$TrackLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Track content) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        final conferenceId =
            GoRouterState.of(context).pathParameters['conferenceId']!;
        final editionId =
            GoRouterState.of(context).pathParameters['editionId']!;

        vyuh.router.push(
            '/conferences/$conferenceId/editions/$editionId/tracks/${content.id}');
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              ClipOval(
                clipBehavior: Clip.antiAlias,
                child: ContentImage(
                  ref: content.icon,
                  height: 48,
                  width: 48,
                ),
              ),
              Expanded(
                child: Text(
                  content.title,
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
