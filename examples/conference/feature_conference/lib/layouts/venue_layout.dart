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

    return Card.outlined(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (content.image != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ContentImage(
                ref: content.image!,
                fit: BoxFit.cover,
              ),
            ),
          ListTile(
            title: Text(content.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (content.description != null) ...[
                  Text(content.description!),
                  const SizedBox(height: 8),
                ],
                if (content.address != null) Text(content.address!.formatted),
                if (content.website != null ||
                    content.phone != null ||
                    content.email != null) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    children: [
                      if (content.website != null)
                        Text(content.website!,
                            style: theme.textTheme.labelMedium),
                      if (content.phone != null)
                        Text(content.phone!,
                            style: theme.textTheme.labelMedium),
                      if (content.email != null)
                        Text(content.email!,
                            style: theme.textTheme.labelMedium),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (content.amenities != null && content.amenities!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Amenities',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
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
            ),
          if (content.rooms != null && content.rooms!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rooms',
                          style: Theme.of(context).textTheme.titleMedium),
                      Chip(
                        avatar: Icon(
                          Icons.meeting_room,
                          color: Colors.white,
                          size: 16,
                        ),
                        label: Text(
                          '${content.rooms!.length}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.blue.shade600,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...content.rooms!.map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: RoomLayout(room: r),
                      )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
