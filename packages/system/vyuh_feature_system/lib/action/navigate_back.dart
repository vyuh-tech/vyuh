import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'navigate_back.g.dart';

@JsonSerializable()
final class NavigateBack extends ActionConfiguration {
  static const schemaName = 'vyuh.action.navigation.back';
  static final typeDescriptor = TypeDescriptor(
    schemaType: NavigateBack.schemaName,
    title: 'Navigate Back',
    fromJson: NavigateBack.fromJson,
  );

  NavigateBack({super.title}) : super(schemaType: schemaName);

  @override
  FutureOr<void> execute(BuildContext context,
      {Map<String, dynamic>? arguments}) {
    if (context.canPop()) {
      Navigator.of(context).pop();
    }
  }

  factory NavigateBack.fromJson(Map<String, dynamic> json) =>
      _$NavigateBackFromJson(json);
}
