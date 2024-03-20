import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;

part 'dialog_layout.g.dart';

enum DialogType { modalBottomSheet, dialog }

@JsonSerializable()
final class DialogRouteLayout extends LayoutConfiguration<vf.Route> {
  static const schemaName = 'vyuh.route.layout.dialog';

  @JsonKey(defaultValue: DialogType.dialog)
  final DialogType dialogType;

  DialogRouteLayout({required this.dialogType}) : super(schemaType: schemaName);

  factory DialogRouteLayout.fromJson(Map<String, dynamic> json) =>
      _$DialogRouteLayoutFromJson(json);

  @override
  Widget build(BuildContext context, vf.Route content) {
    final items = content.regions
        .expand((element) => element.items)
        .toList(growable: false);

    return vf.RouteContainer(
      content: content,
      child: ListView.builder(
        itemBuilder: (context, index) =>
            vyuh.content.buildContent(context, items[index]),
        itemCount: items.length,
      ),
    );
  }
}
