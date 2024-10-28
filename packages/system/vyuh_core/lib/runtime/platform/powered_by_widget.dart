import 'package:flutter/material.dart';

/// A widget that displays the 'Powered by Vyuh' text.
/// The signature of this Framework.
class PoweredByWidget extends StatelessWidget {
  final Color? color;

  /// Creates a [PoweredByWidget]. Only used internally within the framework.
  const PoweredByWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      'Powered by Vyuh',
      style: theme.textTheme.labelSmall
          ?.apply(color: color ?? theme.colorScheme.secondary),
      textAlign: TextAlign.center,
    );
  }
}
