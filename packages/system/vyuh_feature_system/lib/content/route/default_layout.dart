import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;

part 'default_layout.g.dart';

@JsonSerializable()
final class DefaultRouteLayout extends LayoutConfiguration<vf.Route> {
  static const schemaName = '${vf.Route.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Route Layout',
    fromJson: DefaultRouteLayout.fromJson,
  );

  DefaultRouteLayout() : super(schemaType: schemaName);

  factory DefaultRouteLayout.fromJson(Map<String, dynamic> json) =>
      _$DefaultRouteLayoutFromJson(json);

  @override
  Widget build(BuildContext context, vf.Route content) {
    final theme = Theme.of(context);
    final items = content.regions
        .expand((element) => element.items)
        .toList(growable: false);

    return vf.RouteContainer(
      content: content,
      child: Scaffold(
        appBar: AppBar(
          title: Text(content.title),
          scrolledUnderElevation: 1,
          shadowColor: theme.colorScheme.shadow,
        ),
        body: SafeArea(
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, index) {
                return vyuh.content.buildContent(context, items[index]);
              }),
        ),
      ),
    );
  }
}
