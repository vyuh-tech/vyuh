import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/ui/dialog_page.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'route_type.g.dart';

enum PageBehavior { material, cupertino }

enum DialogBehavior { modalBottomSheet, fullscreen }

@JsonSerializable()
final class PageRouteType extends RouteTypeConfiguration {
  static const schemaName = 'vyuh.route.page';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Page Route',
    fromJson: PageRouteType.fromJson,
  );

  final PageBehavior behavior;

  PageRouteType({this.behavior = PageBehavior.material})
      : super(schemaType: PageRouteType.schemaName);

  factory PageRouteType.fromJson(Map<String, dynamic> json) =>
      _$PageRouteTypeFromJson(json);

  @override
  Page<T> create<T>(Widget child, RouteBase route, [LocalKey? pageKey]) {
    return behavior == PageBehavior.material
        ? MaterialPage(
            child: child,
            name: route.path,
            key: pageKey,
          )
        : CupertinoPage(
            child: child,
            name: route.path,
            key: pageKey,
          );
  }
}

@JsonSerializable()
final class DialogRouteType extends RouteTypeConfiguration {
  static const schemaName = 'vyuh.route.dialog';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Dialog Route',
    fromJson: DialogRouteType.fromJson,
  );

  final DialogBehavior behavior;

  DialogRouteType({this.behavior = DialogBehavior.modalBottomSheet})
      : super(schemaType: DialogRouteType.schemaName);

  factory DialogRouteType.fromJson(Map<String, dynamic> json) =>
      _$DialogRouteTypeFromJson(json);

  @override
  Page<T> create<T>(Widget child, RouteBase route, [LocalKey? pageKey]) {
    return switch (behavior) {
      DialogBehavior.modalBottomSheet => ModalDialogPage(
          builder: (context) => child, name: route.path, key: pageKey),
      DialogBehavior.fullscreen =>
        DialogPage(builder: (context) => child, name: route.path, key: pageKey),
    };
  }
}
