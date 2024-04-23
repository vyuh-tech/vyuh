import 'package:collection/collection.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'conditional_action.g.dart';

@JsonSerializable()
class ConditionalAction extends ActionConfiguration {
  static const schemaName = 'vyuh.action.conditional';

  static final typeDescriptor = TypeDescriptor(
    schemaType: ConditionalAction.schemaName,
    title: 'Conditional Action',
    fromJson: ConditionalAction.fromJson,
  );

  @JsonKey(defaultValue: [])
  final List<ActionCase>? cases;

  final String? defaultCase;
  final Condition? condition;

  ConditionalAction({this.cases, this.condition, this.defaultCase})
      : super(schemaType: ConditionalAction.schemaName);

  factory ConditionalAction.fromJson(Map<String, dynamic> json) =>
      _$ConditionalActionFromJson(json);

  @override
  Future<void> execute(flutter.BuildContext context) async {
    final value = (await condition?.execute()) ?? defaultCase;

    if (context.mounted) {
      final caseAction =
          cases?.firstWhereOrNull((element) => element.value == value);

      caseAction?.action?.execute(context);
    }
  }
}

@JsonSerializable()
final class ActionCase {
  final String? value;

  final Action? action;

  ActionCase({this.value, this.action});

  factory ActionCase.fromJson(Map<String, dynamic> json) =>
      _$ActionCaseFromJson(json);
}
