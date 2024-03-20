import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;

part 'sliver_layout.g.dart';

@JsonSerializable()
final class SliverRouteLayout extends LayoutConfiguration<vf.Route> {
  static const schemaName = 'vyuh.route.layout.sliver';

  SliverRouteLayout() : super(schemaType: schemaName);

  factory SliverRouteLayout.fromJson(Map<String, dynamic> json) =>
      _$SliverRouteLayoutFromJson(json);

  @override
  Widget build(BuildContext context, vf.Route content) {
    final items = content.regions
        .expand((element) => element.items)
        .toList(growable: false);

    return vf.RouteContainer(
      content: content,
      child: CustomScrollView(
        primary: true,
        slivers: [
          SliverAppBar(
            centerTitle: true,
            title: Text(content.title),
            pinned: true,
          ),
          SliverList.builder(
            itemBuilder: (context, index) =>
                vyuh.content.buildContent(context, items[index]),
            itemCount: items.length,
          )
        ],
      ),
    );
  }
}
