import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:url_launcher/url_launcher_string.dart';
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (content.photo != null)
            AspectRatio(
              aspectRatio: 1,
              child: ContentImage(
                ref: content.photo!,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (content.tagline != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    content.tagline!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                if (content.bio != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    content.bio!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                if (content.social != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (content.social!.twitter != null)
                        IconButton(
                          icon: const Icon(Icons.flutter_dash),
                          onPressed: () =>
                              launchUrlString(content.social!.twitterUrl!),
                          tooltip: 'Twitter',
                        ),
                      if (content.social!.github != null)
                        IconButton(
                          icon: const Icon(Icons.code),
                          onPressed: () =>
                              launchUrlString(content.social!.githubUrl!),
                          tooltip: 'GitHub',
                        ),
                      if (content.social!.linkedin != null)
                        IconButton(
                          icon: const Icon(Icons.work),
                          onPressed: () =>
                              launchUrlString(content.social!.linkedinUrl!),
                          tooltip: 'LinkedIn',
                        ),
                      if (content.social!.website != null)
                        IconButton(
                          icon: const Icon(Icons.language),
                          onPressed: () =>
                              launchUrlString(content.social!.website!),
                          tooltip: 'Website',
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

@JsonSerializable()
final class SpeakerProfileCardLayout extends LayoutConfiguration<Speaker> {
  static const schemaName = '${Speaker.schemaName}.layout.profile_card';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: SpeakerProfileCardLayout.fromJson,
    title: 'Speaker Profile Card Layout',
  );

  SpeakerProfileCardLayout() : super(schemaType: schemaName);

  factory SpeakerProfileCardLayout.fromJson(Map<String, dynamic> json) =>
      _$SpeakerProfileCardLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Speaker content) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (content.photo != null)
            AspectRatio(
              aspectRatio: 1,
              child: ContentImage(
                ref: content.photo!,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  content.name,
                  style: theme.textTheme.titleMedium,
                ),
                if (content.tagline != null)
                  Text(
                    content.tagline!,
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
