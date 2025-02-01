import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

import '../content/venue.dart';
import '../layouts/room_layout.dart';

part 'venue_layout.g.dart';

@JsonSerializable()
final class VenueLayout extends LayoutConfiguration<Venue> {
  static const schemaName = '${Venue.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: VenueLayout.fromJson,
    title: 'Venue Layout',
  );

  VenueLayout() : super(schemaType: schemaName);

  factory VenueLayout.fromJson(Map<String, dynamic> json) =>
      _$VenueLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Venue content) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        if (content.image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ContentImage(
                ref: content.image!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(content.title, style: theme.textTheme.titleMedium),
            if (content.description != null)
              VyuhBinding.instance.content
                  .buildContent(context, content.description!),
            if (content.address != null) Text(content.address!.formatted),
            if (content.website != null ||
                content.phone != null ||
                content.email != null) ...[
              Wrap(
                spacing: 16,
                children: [
                  if (content.website != null)
                    Text(content.website!, style: theme.textTheme.labelMedium),
                  if (content.phone != null)
                    Text(content.phone!, style: theme.textTheme.labelMedium),
                  if (content.email != null)
                    Text(content.email!, style: theme.textTheme.labelMedium),
                ],
              ),
            ],
          ],
        ),
        if (content.amenities != null && content.amenities!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              Text('Amenities', style: Theme.of(context).textTheme.titleMedium),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: content.amenities!
                    .map((a) => Chip(
                          label: Text(
                            a.displayName,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.grey.shade600,
                        ))
                    .toList(),
              ),
            ],
          ),
        if (content.rooms != null && content.rooms!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              Text('Rooms (${content.rooms!.length})',
                  style: Theme.of(context).textTheme.titleMedium),
              ...content.rooms!.map((r) => RoomLayout(room: r)),
            ],
          ),
      ],
    );
  }
}
