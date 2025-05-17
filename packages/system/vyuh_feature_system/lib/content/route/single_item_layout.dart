import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/ui/single_item_route_scaffold.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'single_item_layout.g.dart';

@JsonSerializable()
final class SingleItemLayout extends LayoutConfiguration<vf.Route> {
  static const schemaName = 'vyuh.route.layout.single';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Single Item Layout',
    fromJson: SingleItemLayout.fromJson,
    preview: () => SingleItemLayout(
        showAppBar: true,
        useSafeArea: true,
        actions: [MenuAction(icon: MenuIconType.settings)]),
  );

  final bool showAppBar;
  final bool useSafeArea;
  final List<MenuAction>? actions;

  SingleItemLayout({
    this.useSafeArea = false,
    this.showAppBar = false,
    this.actions,
  }) : super(schemaType: schemaName);

  factory SingleItemLayout.fromJson(Map<String, dynamic> json) =>
      _$SingleItemLayoutFromJson(json);

  @override
  Widget build(BuildContext context, vf.Route content) {
    return SingleItemRouteScaffold(
      content: content,
      appBar: showAppBar
          ? AppBar(
              title: Text(content.title),
              actions: actions
                  ?.map(
                    (e) => IconButton(
                        onPressed: () => e.action?.execute(context),
                        icon: Icon(e.icon.iconData)),
                  )
                  .toList(growable: false),
            )
          : null,
      useSafeArea: useSafeArea,
    );
  }
}
