import 'package:flutter/material.dart' hide Action;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_auth/ui/form_fields.dart';

part 'hint_action_text.g.dart';

enum HintActionAlignment {
  start,
  end,
  center;

  WrapAlignment get wrapAlignment {
    switch (this) {
      case HintActionAlignment.start:
        return WrapAlignment.start;
      case HintActionAlignment.end:
        return WrapAlignment.end;
      case HintActionAlignment.center:
        return WrapAlignment.center;
    }
  }
}

@JsonSerializable()
final class HintActionText extends ContentItem {
  static const schemaName = 'auth.hintActionText';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Hint Action Text',
    fromJson: HintActionText.fromJson,
  );

  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayout: HintActionTextDefaultLayout(),
    defaultLayoutDescriptor: HintActionTextDefaultLayout.typeDescriptor,
  );

  final String hint;
  final Action? action;
  final HintActionAlignment alignment;

  HintActionText({
    super.layout,
    required this.hint,
    this.action,
    this.alignment = HintActionAlignment.center,
  }) : super(schemaType: schemaName);

  factory HintActionText.fromJson(Map<String, dynamic> json) =>
      _$HintActionTextFromJson(json);
}

final class HintActionTextDescriptor extends ContentDescriptor {
  HintActionTextDescriptor({super.layouts = const []})
      : super(schemaType: HintActionText.schemaName, title: 'Hint Action Text');
}

@JsonSerializable()
final class HintActionTextDefaultLayout
    extends LayoutConfiguration<HintActionText> {
  static const schemaName = '${HintActionText.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: HintActionTextDefaultLayout.fromJson,
    title: 'Hint Action Text Default Layout',
  );

  HintActionTextDefaultLayout() : super(schemaType: schemaName);

  factory HintActionTextDefaultLayout.fromJson(Map<String, dynamic> json) =>
      _$HintActionTextDefaultLayoutFromJson(json);

  @override
  Widget build(BuildContext context, HintActionText content) {
    return HintAction(
      onTap: (_) => content.action?.execute(context),
      hintLabel: HintAction.defaultHintLabel(context, content.hint),
      actionLabel: content.action == null
          ? const SizedBox.shrink()
          : HintAction.defaultActionLabel(context, content.action!.title ?? ''),
      alignment: content.alignment.wrapAlignment,
    );
  }
}
