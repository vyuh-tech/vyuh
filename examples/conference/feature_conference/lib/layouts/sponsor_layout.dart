import 'package:feature_conference/content/sponsor.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

part 'sponsor_layout.g.dart';

extension on SponsorLevel {
  Color get color {
    switch (this) {
      case SponsorLevel.platinum:
        return Colors.grey.shade700;
      case SponsorLevel.gold:
        return Colors.amber.shade700;
      case SponsorLevel.silver:
        return Colors.grey.shade500;
      case SponsorLevel.bronze:
        return Colors.brown.shade400;
    }
  }
}

@JsonSerializable()
final class SponsorLayout extends LayoutConfiguration<Sponsor> {
  static const schemaName = '${Sponsor.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: SponsorLayout.fromJson,
    title: 'Sponsor Layout',
  );

  SponsorLayout() : super(schemaType: schemaName);

  factory SponsorLayout.fromJson(Map<String, dynamic> json) =>
      _$SponsorLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Sponsor content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (content.logo != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ContentImage(
                  ref: content.logo!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            Text(
              content.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (content.url != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Add url launch functionality
                },
                child: Text('Visit Website'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
