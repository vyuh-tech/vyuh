import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

import '../content/edition.dart';

part 'edition_layout.g.dart';

@JsonSerializable()
final class EditionLayout extends LayoutConfiguration<Edition> {
  static const schemaName = '${Edition.schemaName}.layout.default';
  final String? title;
  final String? subtitle;

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: EditionLayout.fromJson,
    title: 'Edition Layout',
  );

  EditionLayout({
    required this.title,
    required this.subtitle,
  }) : super(schemaType: schemaName);

  factory EditionLayout.fromJson(Map<String, dynamic> json) =>
      _$EditionLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Edition content) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(content.title),
            subtitle: Text(content.tagline),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${content.startDate.toLocal()} - ${content.endDate.toLocal()}'),
                Text(content.location),
                if (content.url != null) Text(content.url!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
