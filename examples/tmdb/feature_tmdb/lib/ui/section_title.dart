import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.spacing.s8),
      child: Text(
        title,
        style: theme.tmdbTheme.headlineMedium?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
