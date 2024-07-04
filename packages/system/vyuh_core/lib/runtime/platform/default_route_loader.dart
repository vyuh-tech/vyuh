part of 'default_platform_widget_builder.dart';

class _DefaultRouteLoader extends StatefulWidget {
  final Duration delay;
  final Color? backgroundColor;
  final Color? progressColor;

  const _DefaultRouteLoader({
    this.backgroundColor,
    this.progressColor,
    this.delay = const Duration(seconds: 1),
  });

  @override
  State<_DefaultRouteLoader> createState() => _DefaultRouteLoaderState();
}

class _DefaultRouteLoaderState extends State<_DefaultRouteLoader> {
  late final Timer _timer;
  bool _isTimerDone = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      setState(() {
        _isTimerDone = true;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressColor =
        widget.progressColor ?? Theme.of(context).colorScheme.primary;

    final body = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FractionallySizedBox(
              widthFactor: 0.5,
              child: RepaintBoundary(
                child: LinearProgressIndicator(
                  backgroundColor: progressColor.withOpacity(0.25),
                  color: progressColor,
                ),
              ),
            ),
            const PoweredByWidget(),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: _isTimerDone ? body : null,
    );
  }
}
