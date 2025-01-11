import 'package:flutter/material.dart';

final class NoPreviewCard extends StatelessWidget {
  final String title;
  final String message;

  const NoPreviewCard({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '''
No Preview available for "$title".
         
Make sure to supply the 'preview' parameter for $message.
          ''',
          style: theme.textTheme.labelLarge?.apply(
            fontFamily: 'Courier',
            color: theme.colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }
}
