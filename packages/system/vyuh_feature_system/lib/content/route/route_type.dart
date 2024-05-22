import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_feature_system/ui/dialog_page.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'route_type.g.dart';

enum PageBehavior { material, cupertino }

enum DialogBehavior { modalBottomSheet, fullscreen }

@JsonSerializable()
final class PageRouteType extends vc.RouteTypeConfiguration {
  static const schemaName = 'vyuh.route.page';

  final PageBehavior behavior;

  PageRouteType({this.behavior = PageBehavior.material})
      : super(schemaType: PageRouteType.schemaName);

  factory PageRouteType.fromJson(Map<String, dynamic> json) =>
      _$PageRouteTypeFromJson(json);

  @override
  Page<T> create<T>(Widget child, vc.RouteBase route) {
    return behavior == PageBehavior.material
        ? MaterialPage(child: child, name: route.path)
        : CupertinoPage(child: child, name: route.path);
  }
}

@JsonSerializable()
final class DialogRouteType extends vc.RouteTypeConfiguration {
  static const schemaName = 'vyuh.route.dialog';

  final DialogBehavior behavior;

  DialogRouteType({this.behavior = DialogBehavior.modalBottomSheet})
      : super(schemaType: DialogRouteType.schemaName);

  factory DialogRouteType.fromJson(Map<String, dynamic> json) =>
      _$DialogRouteTypeFromJson(json);

  @override
  Page<T> create<T>(Widget child, vc.RouteBase route) {
    return switch (behavior) {
      DialogBehavior.modalBottomSheet =>
        ModalDialogPage(builder: (context) => child),
      DialogBehavior.fullscreen => DialogPage(builder: (context) => child),
    };
  }
}
