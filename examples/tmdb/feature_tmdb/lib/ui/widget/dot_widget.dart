import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DotWidget extends StatelessWidget {
  const DotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: theme.sizing.s2,
      height: theme.sizing.s2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.outline,
      ),
    );
  }
}
