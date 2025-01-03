import 'package:feature_conference/content/speaker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'speaker_chip_layout.g.dart';

@JsonSerializable()
final class SpeakerChipLayout extends LayoutConfiguration<Speaker> {
  static const schemaName = '${Speaker.schemaName}.layout.chip';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: SpeakerChipLayout.fromJson,
    title: 'Speaker Chip Layout',
  );

  final bool mini;

  SpeakerChipLayout({this.mini = false}) : super(schemaType: schemaName);

  factory SpeakerChipLayout.fromJson(Map<String, dynamic> json) =>
      _$SpeakerChipLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Speaker content) {
    final size = mini ? 32.0 : 48.0;
    final radius = size / 2;

    return GestureDetector(
      onTap: () {
        final conferenceId =
            GoRouterState.of(context).pathParameters['conferenceId']!;
        final editionId =
            GoRouterState.of(context).pathParameters['editionId']!;

        vyuh.router.push(
            '/conferences/$conferenceId/editions/$editionId/speakers/${content.id}');
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          if (content.photo != null)
            ClipOval(
              child: ContentImage(
                ref: content.photo!,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            )
          else
            CircleAvatar(
              radius: radius,
              child: Icon(Icons.person, size: radius),
            ),
          Text(
            content.name,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
