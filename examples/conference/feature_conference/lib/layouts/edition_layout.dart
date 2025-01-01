import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

import '../content/edition.dart';
import '../utils.dart';

part 'edition_layout.g.dart';

@JsonSerializable()
final class EditionLayout extends LayoutConfiguration<Edition> {
  static const schemaName = '${Edition.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: EditionLayout.fromJson,
    title: 'Edition Layout',
  );

  EditionLayout() : super(schemaType: schemaName);

  factory EditionLayout.fromJson(Map<String, dynamic> json) =>
      _$EditionLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Edition content) {
    return GestureDetector(
      onTap: () {
        vyuh.router.push(
            '/conference/${content.conference.ref}/editions/${content.id}');
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (content.logo != null)
              ContentImage(
                ref: content.logo,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ListTile(
              leading: const Icon(Icons.event),
              title: Text(content.title),
              subtitle: Text(content.tagline),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${dayFormat.format(content.startDate.toLocal())} - ${dayFormat.format(content.endDate.toLocal())}'),
                  if (content.venue != null)
                    Text(content.venue!.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (content.url != null)
                    Row(
                      spacing: 8,
                      children: [
                        const Icon(Icons.link),
                        Expanded(child: Text(content.url!)),
                      ],
                    ),
                ],
              ),
            ),
            OverflowBar(
              children: [
                TextButton.icon(
                  onPressed: () {
                    context.push(
                        '/conference/${content.conference.ref}/editions/${content.id}/speakers');
                  },
                  icon: const Icon(Icons.people),
                  label: const Text('Speakers'),
                ),
                TextButton.icon(
                  onPressed: () {
                    context.push(
                        '/conference/${content.conference.ref}/editions/${content.id}/tracks');
                  },
                  icon: const Icon(Icons.view_column),
                  label: const Text('Tracks'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
