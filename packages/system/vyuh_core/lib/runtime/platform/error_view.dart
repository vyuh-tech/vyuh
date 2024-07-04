part of 'default_platform_widget_builder.dart';

class _ErrorViewScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final dynamic error;
  final VoidCallback? onRetry;
  final bool showRestart;

  final String? retryLabel;

  const _ErrorViewScaffold({
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

    final backgroundColor = theme.colorScheme.errorContainer;
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
                    }),
              const PoweredByWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String title;
  final String? subtitle;
  final dynamic error;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const _ErrorView({
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
        color: theme.colorScheme.errorContainer,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Icon(
              Icons.hide_source_rounded,
              color: textColor,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.apply(color: textColor)),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(subtitle!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall?.apply(color: textColor)),
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
            const PoweredByWidget(),
          ],
        ),
      ),
    );
  }
}
