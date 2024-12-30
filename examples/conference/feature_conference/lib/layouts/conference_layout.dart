import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

import '../content/conference.dart';

part 'conference_layout.g.dart';

@JsonSerializable()
final class ConferenceLayout extends LayoutConfiguration<Conference> {
  static const schemaName = '${Conference.schemaName}.layout.default';
  final String? title;
  final String? subtitle;

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: ConferenceLayout.fromJson,
    title: 'Conference Layout',
  );

  ConferenceLayout({
    required this.title,
    required this.subtitle,
  }) : super(schemaType: schemaName);

  factory ConferenceLayout.fromJson(Map<String, dynamic> json) =>
      _$ConferenceLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Conference content) {
    return Card(
      child: ListTile(
        leading: content.iconUrl != null
            ? Image.network(content.iconUrl!)
            : const Icon(Icons.event),
        title: Text(content.title),
        subtitle: Text(content.identifier),
      ),
    );
  }
}
