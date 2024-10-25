import 'dart:async';

import 'package:feature_tmdb/content/dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'drop_down_selection.g.dart';

@JsonSerializable()
final class DropDownSelection extends ActionConfiguration {
  static const schemaName = 'tmdb.action.dropDownSelection';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: DropDownSelection.fromJson,
    title: 'Drop Down Selection',
  );

  DropDownSelection({super.isAwaited}) : super(schemaType: schemaName);

  factory DropDownSelection.fromJson(Map<String, dynamic> json) =>
      _$DropDownSelectionFromJson(json);

  @override
  FutureOr<void> execute(
    BuildContext context, {
    Map<String, dynamic>? arguments,
  }) {
    final item = arguments?[DropDownMenu.schemaName];
    if (item != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected item: ${(item as DropDownItem).title}'),
          duration: const Duration(milliseconds: 500),
        ),
      );
    }
  }
}
