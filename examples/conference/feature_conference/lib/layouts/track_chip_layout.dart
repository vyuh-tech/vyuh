import 'package:feature_conference/content/track.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'track_chip_layout.g.dart';

@JsonSerializable()
final class TrackChipLayout extends LayoutConfiguration<Track> {
  static const schemaName = '${Track.schemaName}.layout.chip';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: TrackChipLayout.fromJson,
    title: 'Track Chip Layout',
  );

  TrackChipLayout() : super(schemaType: schemaName);

  factory TrackChipLayout.fromJson(Map<String, dynamic> json) =>
      _$TrackChipLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Track content) {
    return GestureDetector(
      onTap: () {
        final conferenceId =
            GoRouterState.of(context).pathParameters['conferenceId']!;
        final editionId =
            GoRouterState.of(context).pathParameters['editionId']!;
        vyuh.router.push(
            '/conferences/$conferenceId/editions/$editionId/tracks/${content.id}');
      },
      child: Chip(
        avatar: const Icon(Icons.view_column),
        label: Text(content.title),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
