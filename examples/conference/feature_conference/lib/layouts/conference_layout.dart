import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

import '../content/conference.dart';

part 'conference_layout.g.dart';

@JsonSerializable()
final class ConferenceLayout extends LayoutConfiguration<Conference> {
  static const schemaName = '${Conference.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: ConferenceLayout.fromJson,
    title: 'Conference Layout',
  );

  ConferenceLayout() : super(schemaType: schemaName);

  factory ConferenceLayout.fromJson(Map<String, dynamic> json) =>
      _$ConferenceLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Conference content) {
    return GestureDetector(
      onTap: () {
        vyuh.router.push('/conference/${content.id}');
      },
      child: Card(
        child: Column(
          children: [
            ContentImage(ref: content.logo),
            ListTile(
              title: Text(content.title),
              subtitle: Text(content.slug),
            ),
          ],
        ),
      ),
    );
  }
}
