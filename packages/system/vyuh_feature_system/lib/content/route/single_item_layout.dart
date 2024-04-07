import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;

part 'single_item_layout.g.dart';

@JsonSerializable()
final class SingleItemLayout extends LayoutConfiguration<vf.Route> {
  static const schemaName = 'vyuh.route.layout.single';

  final bool useSafeArea;

  SingleItemLayout({this.useSafeArea = false}) : super(schemaType: schemaName);

  factory SingleItemLayout.fromJson(Map<String, dynamic> json) =>
      _$SingleItemLayoutFromJson(json);

  @override
  Widget build(BuildContext context, vf.Route content) {
    final first =
        content.regions.expand((element) => element.items).firstOrNull;

    if (first == null) {
      return vf.empty;
    }

    final child = vyuh.content.buildContent(context, first);

    return vf.RouteContainer(
      content: content,
      child: Scaffold(body: useSafeArea ? SafeArea(child: child) : child),
    );
  }
}
