import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

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

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Row(
        spacing: 8,
        children: [
          if (content.icon != null)
            SizedBox(
              width: 64,
              height: 64,
              child: ContentImage(
                ref: content.icon!,
                fit: BoxFit.contain,
              ),
            ),
          Expanded(
            child: Text(
              content.title,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
