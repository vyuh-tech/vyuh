import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/runtime/platform/powered_by_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// Makes the current [VyuhFailure] available to error views below it.
///
/// [PlatformWidgetBuilder.routeErrorView] and [PlatformWidgetBuilder.errorView]
/// keep their simple signatures; a custom builder that needs the failure kind
/// or location reads it with [VyuhFailureScope.maybeOf].
class VyuhFailureScope extends InheritedWidget {
  /// The failure being shown.
  final VyuhFailure failure;

  const VyuhFailureScope({
    super.key,
    required this.failure,
    required super.child,
  });

  /// The nearest failure, or null when the view was built outside one.
  static VyuhFailure? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VyuhFailureScope>()?.failure;

  @override
  bool updateShouldNotify(VyuhFailureScope oldWidget) =>
      failure != oldWidget.failure;
}

/// The recovery actions that apply in a given context. Every error view
/// offers the same choices in the same order: Retry, Go home, Back, Restart.
abstract final class FailureActions {
  /// Whether there is a page to go back to.
  static bool canGoBack(BuildContext context) =>
      GoRouter.maybeOf(context)?.canPop() ?? false;

  /// Whether "Go home" can help: the router exists, the failure allows it,
  /// and the failure is not on the home route itself.
  static bool canGoHome(BuildContext context, [VyuhFailure? failure]) {
    if (GoRouter.maybeOf(context) == null) return false;
    if (failure != null && !failure.canGoHome) return false;
    final home = vyuh.router.homeLocation;
    return failure?.location == null || failure!.location!.path != home;
  }

  /// Whether only a restart can help: there is no router yet, or the
  /// platform failed to initialize.
  static bool needsRestart(BuildContext context, [VyuhFailure? failure]) =>
      failure?.kind == FailureKind.init ||
      GoRouter.maybeOf(context) == null ||
      (!canGoHome(context, failure) && !canGoBack(context));

  /// Goes back one page.
  static void goBack(BuildContext context) => GoRouter.of(context).pop();

  /// Goes to the home route.
  static void goHome() => vyuh.router.goHome();

  /// Restarts the platform. This rebuilds the whole app, so it is the last
  /// resort.
  static void restart() => vyuh.tracker.init();
}

/// Shows a route-level failure through [PlatformWidgetBuilder.routeErrorView]
/// and reports it once, to telemetry and as a [RouteFailureEvent].
///
/// Use this wherever a route cannot be shown. A new [key] reports again.
class RouteFailureView extends StatefulWidget {
  /// The failure to show.
  final VyuhFailure failure;

  /// Re-runs only the failed operation. Hidden when null.
  final VoidCallback? onRetry;

  /// The label of the retry button.
  final String? retryLabel;

  const RouteFailureView({
    super.key,
    required this.failure,
    this.onRetry,
    this.retryLabel,
  });

  @override
  State<RouteFailureView> createState() => _RouteFailureViewState();
}

class _RouteFailureViewState extends State<RouteFailureView> {
  @override
  void initState() {
    super.initState();
    reportFailure(widget.failure);
  }

  @override
  Widget build(BuildContext context) {
    final failure = widget.failure;
    return VyuhFailureScope(
      failure: failure,
      child: Builder(
        builder: (context) => vyuh.widgetBuilder.routeErrorView(
          context,
          title: failure.title,
          subtitle: failure.message,
          error: failure.error,
          stackTrace: failure.stackTrace,
          onRetry: widget.onRetry,
          retryLabel: widget.retryLabel,
        ),
      ),
    );
  }
}

/// The default full-page failure: a themed page with a clear message and the
/// recovery actions that apply. Error details appear only in debug builds.
class FailurePage extends StatelessWidget {
  final String title;
  final String? message;
  final Object? error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;
  final String? retryLabel;

  /// Shows Restart even when other actions are available.
  final bool showRestart;

  const FailurePage({
    super.key,
    required this.title,
    this.message,
    this.error,
    this.stackTrace,
    this.onRetry,
    this.retryLabel,
    this.showRestart = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = VyuhThemeExtension.of(context);
    final failure = VyuhFailureScope.maybeOf(context);
    final canGoBack = FailureActions.canGoBack(context);
    final canGoHome = FailureActions.canGoHome(context, failure);
    final restart =
        showRestart || FailureActions.needsRestart(context, failure);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: canGoBack
            ? BackButton(onPressed: () => FailureActions.goBack(context))
            : null,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _FailureIcon(kind: failure?.kind, size: 40, tokens: tokens),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall,
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      message!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      if (onRetry != null)
                        FilledButton.icon(
                          onPressed: onRetry,
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(
                            retryLabel ?? VyuhStrings.current.tryAgain,
                          ),
                        ),
                      if (canGoHome)
                        OutlinedButton.icon(
                          onPressed: FailureActions.goHome,
                          icon: const Icon(Icons.home_rounded),
                          label: Text(VyuhStrings.current.goHome),
                        ),
                      if (restart)
                        TextButton(
                          onPressed: FailureActions.restart,
                          child: Text(VyuhStrings.current.restartApp),
                        ),
                    ],
                  ),
                  if (kDebugMode &&
                      (error != null || failure?.location != null))
                    _FailureDetails(
                      error: error,
                      stackTrace: stackTrace,
                      location: failure?.location,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The default inline failure, used inside a page for a part that failed.
class FailureCard extends StatelessWidget {
  final String title;
  final String? message;
  final Object? error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final bool showRestart;

  const FailureCard({
    super.key,
    required this.title,
    this.message,
    this.error,
    this.stackTrace,
    this.onRetry,
    this.retryLabel,
    this.showRestart = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = VyuhThemeExtension.of(context);
    final foreground = tokens.failureForeground!;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: tokens.failureBackground,
        borderRadius: BorderRadius.circular(tokens.radius!),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.error_outline_rounded, color: foreground),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: foreground,
                      ),
                    ),
                  ),
                ],
              ),
              if (message != null) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 36),
                  child: Text(
                    message!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: foreground,
                    ),
                  ),
                ),
              ],
              if (onRetry != null || showRestart)
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 8),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      if (onRetry != null)
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: foreground,
                          ),
                          onPressed: onRetry,
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(
                            retryLabel ?? VyuhStrings.current.tryAgain,
                          ),
                        ),
                      if (showRestart)
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: foreground,
                          ),
                          onPressed: FailureActions.restart,
                          child: Text(VyuhStrings.current.restartApp),
                        ),
                    ],
                  ),
                ),
              if (kDebugMode && error != null)
                _FailureDetails(
                  error: error,
                  stackTrace: stackTrace,
                  color: foreground,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown in release builds in place of a widget that failed to build.
/// Small, quiet and themed, so one broken widget does not break the page.
class BuildFailureView extends StatelessWidget {
  final FlutterErrorDetails details;

  const BuildFailureView({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = VyuhThemeExtension.fallback(theme.colorScheme);
    return Directionality(
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      child: LimitedBox(
        maxWidth: 96,
        maxHeight: 96,
        child: ColoredBox(
          color: tokens.placeholderBackground!,
          child: Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: tokens.placeholderForeground,
              semanticLabel: VyuhStrings.current.contentUnavailable,
            ),
          ),
        ),
      ),
    );
  }
}

class _FailureIcon extends StatelessWidget {
  final FailureKind? kind;
  final double size;
  final VyuhThemeExtension tokens;

  const _FailureIcon({
    required this.kind,
    required this.size,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final icon = switch (kind) {
      FailureKind.notFound => Icons.explore_off_rounded,
      FailureKind.featureDisabled => Icons.block_rounded,
      FailureKind.featureLoad => Icons.cloud_off_rounded,
      FailureKind.init => Icons.power_off_rounded,
      _ => Icons.error_outline_rounded,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.failureBackground,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(size / 2),
        child: Icon(icon, size: size, color: tokens.failureForeground),
      ),
    );
  }
}

class _FailureDetails extends StatelessWidget {
  final Object? error;
  final StackTrace? stackTrace;
  final Uri? location;
  final Color? color;

  const _FailureDetails({
    this.error,
    this.stackTrace,
    this.location,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall?.copyWith(
      fontFamily: 'monospace',
      color: color ?? theme.colorScheme.onSurfaceVariant,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ExpansionTile(
        title: Text(
          VyuhStrings.current.details,
          style: theme.textTheme.labelLarge?.copyWith(color: color),
        ),
        iconColor: color,
        collapsedIconColor: color,
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (location != null)
            SelectableText('Location: $location', style: style),
          if (error != null) SelectableText('$error', style: style),
          if (stackTrace != null) ...[
            const SizedBox(height: 8),
            SelectableText('$stackTrace', style: style, maxLines: 20),
          ],
        ],
      ),
    );
  }
}

/// "Powered by Vyuh", shown when the theme allows it.
class VyuhBranding extends StatelessWidget {
  const VyuhBranding({super.key});

  @override
  Widget build(BuildContext context) =>
      VyuhThemeExtension.of(context).showPoweredBy!
      ? const PoweredByWidget()
      : const SizedBox.shrink();
}
