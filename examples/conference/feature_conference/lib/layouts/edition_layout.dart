import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

import '../content/edition.dart';

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
                      '${content.startDate.toLocal()} - ${content.endDate.toLocal()}'),
                  Text(content.location,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (content.url != null)
                    Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.link),
                        Expanded(child: Text(content.url!)),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
