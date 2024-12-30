import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

import '../content/speaker.dart';

part 'speaker_layout.g.dart';

@JsonSerializable()
final class SpeakerLayout extends LayoutConfiguration<Speaker> {
  static const schemaName = '${Speaker.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: SpeakerLayout.fromJson,
    title: 'Speaker Layout',
  );

  SpeakerLayout() : super(schemaType: schemaName);

  factory SpeakerLayout.fromJson(Map<String, dynamic> json) =>
      _$SpeakerLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Speaker content) {
    return Card(
      child: ListTile(
        leading: content.photo != null
            ? CircleAvatar(child: ContentImage(ref: content.photo))
            : const CircleAvatar(child: Icon(Icons.person)),
        title: Text(content.name),
        subtitle: Text(content.bio),
      ),
    );
  }
}
