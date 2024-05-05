import 'package:flutter/material.dart';

class PoweredByWidget extends StatelessWidget {
  const PoweredByWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      'Powered by Vyuh',
      style:
          theme.textTheme.labelSmall?.apply(color: theme.colorScheme.secondary),
      textAlign: TextAlign.center,
    );
  }
}
