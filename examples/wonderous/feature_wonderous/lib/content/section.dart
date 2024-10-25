import 'package:feature_wonderous/api/wonder.dart';
import 'package:feature_wonderous/ui/sections/construction_section.dart';
import 'package:feature_wonderous/ui/sections/events_section.dart';
import 'package:feature_wonderous/ui/sections/hero_section.dart';
import 'package:feature_wonderous/ui/sections/history_section.dart';
import 'package:feature_wonderous/ui/sections/location_info_section.dart';
import 'package:feature_wonderous/ui/sections/photos_section.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'section.g.dart';

enum WonderSectionType {
  hero,
  history,
  construction,
  locationInfo,
  events,
  photos,
}

@JsonSerializable()
final class WonderSectionConfiguration
    extends DocumentItemConfiguration<Wonder> {
  static const schemaName = '${Wonder.schemaName}.section';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Wonder Section',
    fromJson: WonderSectionConfiguration.fromJson,
  );

  final WonderSectionType type;

  WonderSectionConfiguration({
    super.title,
    this.type = WonderSectionType.hero,
  }) : super(schemaType: schemaName);

  factory WonderSectionConfiguration.fromJson(Map<String, dynamic> json) =>
      _$WonderSectionConfigurationFromJson(json);

  @override
  Widget build(BuildContext context, Wonder document) {
    return switch (type) {
      WonderSectionType.hero => WonderHeroSection(wonder: document),
      WonderSectionType.history =>
        WonderHistorySection(title: title, wonder: document),
      WonderSectionType.construction =>
        WonderConstructionSection(title: title, wonder: document),
      WonderSectionType.locationInfo =>
        WonderLocationInfoSection(title: title, wonder: document),
      WonderSectionType.events => WonderEventsSection(wonder: document),
      WonderSectionType.photos => WonderPhotosSection(wonder: document),
    };
  }
}
