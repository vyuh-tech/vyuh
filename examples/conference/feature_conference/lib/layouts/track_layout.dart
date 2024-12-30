import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

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
    return Card(
      child: ListTile(
        leading: const Icon(Icons.timeline),
        title: Text(content.name),
      ),
    );
  }
}
