import 'package:flutter/material.dart' hide Card;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'button_layout.g.dart';

enum ButtonType {
  filled,
  outlined,
  text,
}

@JsonSerializable()
final class ButtonCardLayout extends LayoutConfiguration<Card> {
  static const schemaName = '${Card.schemaName}.layout.button';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Button Layout',
    fromJson: ButtonCardLayout.fromJson,
  );

  final ButtonType buttonType;
  final bool isStretched;

  ButtonCardLayout(
      {this.buttonType = ButtonType.filled, this.isStretched = false})
      : super(schemaType: schemaName);

  factory ButtonCardLayout.fromJson(Map<String, dynamic> json) =>
      _$ButtonCardLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Card content) {
    final theme = Theme.of(context);
    final innerChild = Text(content.title ?? 'Untitled');
    final onPressedAction =
        content.action != null ? () => content.action!.execute(context) : null;

    final button = switch (buttonType) {
      ButtonType.filled => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          onPressed: onPressedAction,
          child: innerChild,
        ),
      ButtonType.outlined => OutlinedButton(
          onPressed: onPressedAction,
          child: innerChild,
        ),
      ButtonType.text => TextButton(
          onPressed: onPressedAction,
          child: innerChild,
        ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: isStretched
          ? SizedBox(
              width: double.maxFinite,
              child: button,
            )
          : button,
    );
  }
}
