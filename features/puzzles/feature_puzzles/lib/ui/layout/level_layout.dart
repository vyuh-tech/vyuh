import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;

part 'level_layout.g.dart';

@JsonSerializable(createToJson: false)
final class LevelLayout extends LayoutConfiguration<vf.Route> {
  static const schemaName = 'puzzles.route.layout.level';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Puzzles Level Layout',
    fromJson: LevelLayout.fromJson,
  );

  LevelLayout() : super(schemaType: schemaName);

  factory LevelLayout.fromJson(Map<String, dynamic> json) =>
      _$LevelLayoutFromJson(json);

  @override
  Widget build(BuildContext context, vf.Route content) {
    final first =
        content.regions.expand((element) => element.items).firstOrNull;

    final child =
        first == null ? vf.empty : vyuh.content.buildContent(context, first);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: child,
      ),
    );
  }
}
