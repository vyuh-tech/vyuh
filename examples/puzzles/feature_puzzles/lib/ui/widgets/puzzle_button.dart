import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';

class PuzzleButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const PuzzleButton({
    super.key,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NeoPopButton(
      color: color ?? theme.colorScheme.primary,
      buttonPosition: Position.center,
      onTapUp: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.s16,
          vertical: theme.spacing.s8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
