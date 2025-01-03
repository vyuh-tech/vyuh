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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        if (content.logo != null)
          ContentImage(
            ref: content.logo,
            height: 200,
            fit: BoxFit.cover,
          ),
        Text(content.title, style: theme.textTheme.headlineMedium),
        if (content.description != null)
          vyuh.content.buildContent(context, content.description!),
      ],
    );
  }
}
