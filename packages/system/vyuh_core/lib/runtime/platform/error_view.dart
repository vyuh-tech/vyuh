import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

class ErrorViewScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final dynamic error;
  final VoidCallback? onRetry;
  final bool showRestart;

  final String? retryLabel;

  const ErrorViewScaffold({
    super.key,
    this.title = 'Something is not right!',
    this.subtitle,
    this.error,
    this.onRetry,
    this.showRestart = true,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.hide_source_rounded,
                color: textColor,
                size: 64,
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(subtitle!,
                      textAlign: TextAlign.center,
                      style:
                          theme.textTheme.titleMedium?.apply(color: textColor)),
                ),
              Expanded(
                  child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    if (error != null)
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodyMedium?.apply(
                          fontFamily: 'Courier',
                          fontWeightDelta: 2,
                          fontSizeDelta: 1,
                          color: textColor,
                        ),
                      ),
                  ],
                ),
              )),
              if (onRetry != null)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                  child: FilledButton(
                      onPressed: onRetry, child: Text(retryLabel ?? 'Retry')),
                ),
              if (showRestart)
                TextButton(
                    child: Text('Restart',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: textColor)),
                    onPressed: () {
                      vyuh.tracker.init();
                    })
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String title;
  final String? subtitle;
  final dynamic error;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const ErrorView({
    super.key,
    this.title = 'Something is not right!',
    this.subtitle,
    this.error,
    this.onRetry,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.colorScheme.onSurface;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 100, maxHeight: 200),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.hide_source_rounded,
              color: textColor,
              size: 32,
            ),
            Text(title, textAlign: TextAlign.center),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(subtitle!,
                    textAlign: TextAlign.center,
                    style:
                        theme.textTheme.titleMedium?.apply(color: textColor)),
              ),
            Expanded(
                child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  if (error != null)
                    Text(
                      error.toString(),
                      style: theme.textTheme.bodyMedium?.apply(
                        fontFamily: 'Courier',
                        fontWeightDelta: 2,
                        fontSizeDelta: 1,
                        color: textColor,
                      ),
                    ),
                ],
              ),
            )),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                child: FilledButton(
                    onPressed: onRetry, child: Text(retryLabel ?? 'Retry')),
              ),
          ],
        ),
      ),
    );
  }
}
