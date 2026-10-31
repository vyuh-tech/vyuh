part of '../platform_widget_builder.dart';

/// The default loaders. They wait for the theme's `loaderDelay` before
/// appearing, so fast loads don't flash, and use only theme colors.
class _DefaultLoader extends StatefulWidget {
  /// Full-screen app loader (true) or in-app route/content loader (false).
  final bool fullScreen;

  /// Shows a linear bar (routes, app) or a spinner (content).
  final bool linear;

  const _DefaultLoader({this.fullScreen = false, this.linear = true});

  @override
  State<_DefaultLoader> createState() => _DefaultLoaderState();
}

class _DefaultLoaderState extends State<_DefaultLoader> {
  Timer? _timer;
  bool _visible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_timer != null || _visible) return;
    final delay = widget.fullScreen
        ? Duration.zero
        : VyuhThemeExtension.of(context).loaderDelay!;
    // Even with no delay, start the indicator's animation after the first
    // frame rather than during the initial mount.
    _timer = Timer(delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = VyuhThemeExtension.of(context);
    final color = tokens.loaderColor!;

    final indicator = widget.linear
        ? SizedBox(
            width: 160,
            child: LinearProgressIndicator(
              color: color,
              backgroundColor: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          )
        : CircularProgressIndicator(color: color);

    final body = !_visible
        ? const SizedBox.shrink()
        : Center(
            child: Semantics(
              label: VyuhStrings.current.loading,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RepaintBoundary(child: indicator),
                  if (widget.fullScreen) ...[
                    const SizedBox(height: 16),
                    const VyuhBranding(),
                  ],
                ],
              ),
            ),
          );

    if (!widget.fullScreen && !widget.linear) {
      return Padding(padding: const EdgeInsets.all(16), child: body);
    }

    return Scaffold(
      backgroundColor: widget.fullScreen
          ? tokens.appLoaderBackground
          : tokens.routeLoaderBackground,
      body: body,
    );
  }
}
