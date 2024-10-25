import 'dart:async';

import 'package:feature_puzzles/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as go;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'select_level.g.dart';

@JsonSerializable(createToJson: false)
final class SelectLevel extends ActionConfiguration {
  static const schemaName = 'puzzles.action.selectLevel';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: SelectLevel.fromJson,
    title: 'Select Level',
  );

  @JsonKey(name: 'puzzleLevel')
  final ObjectReference? level;

  SelectLevel({this.level, super.isAwaited}) : super(schemaType: schemaName);

  factory SelectLevel.fromJson(Map<String, dynamic> json) =>
      _$SelectLevelFromJson(json);

  @override
  FutureOr<void> execute(
    BuildContext context, {
    Map<String, dynamic>? arguments,
  }) {
    if (level != null) {
      context.push('${PuzzlesPath.puzzlesLevel}/${level!.ref}');
    }
  }
}
