import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/content/group/default_layout.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'carousel_layout.g.dart';

@JsonSerializable()
final class CarouselGroupLayout extends LayoutConfiguration<Group> {
  static const schemaName = '${Group.schemaName}.layout.carousel';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Carousel Group Layout',
    fromJson: CarouselGroupLayout.fromJson,
  );

  final double viewportFraction;

  CarouselGroupLayout({this.viewportFraction = 0.75})
      : super(schemaType: schemaName);

  factory CarouselGroupLayout.fromJson(Map<String, dynamic> json) =>
      _$CarouselGroupLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Group content) {
    return GroupLayoutContainer(
      content: content,
      body: Carousel(
        content: content,
        viewportFraction: viewportFraction,
      ),
    );
  }
}
