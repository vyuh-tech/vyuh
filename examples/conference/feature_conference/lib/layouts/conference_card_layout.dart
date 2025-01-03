import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

import '../content/conference.dart';

part 'conference_card_layout.g.dart';

@JsonSerializable()
final class ConferenceCardLayout extends LayoutConfiguration<Conference> {
  static const schemaName = '${Conference.schemaName}.layout.card';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: ConferenceCardLayout.fromJson,
    title: 'Conference Card Layout',
  );

  ConferenceCardLayout() : super(schemaType: schemaName);

  factory ConferenceCardLayout.fromJson(Map<String, dynamic> json) =>
      _$ConferenceCardLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Conference content) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        vyuh.router.push('/conferences/${content.id}');
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: ContentImage(
                  ref: content.logo,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        theme.colorScheme.primary.withValues(alpha: 0.75),
                        theme.colorScheme.primary.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    content.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
