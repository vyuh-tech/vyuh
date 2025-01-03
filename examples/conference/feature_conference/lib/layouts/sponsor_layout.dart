import 'package:feature_conference/content/sponsor.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

part 'sponsor_layout.g.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        if (content.logo != null)
          ContentImage(
            ref: content.logo!,
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        Text(
          content.name,
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
