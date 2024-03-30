import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

class StandardPluginView extends StatelessWidget {
  final Plugin plugin;

  const StandardPluginView({super.key, required this.plugin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          plugin.title,
          style: theme.textTheme.bodyLarge
              ?.apply(fontWeightDelta: 2, color: theme.colorScheme.primary),
        ),
        Text(plugin.name,
            style:
                theme.textTheme.labelMedium?.apply(color: theme.disabledColor)),
        const SizedBox(height: 4),
        Text('${plugin.runtimeType}'),
      ],
    );
  }
}
