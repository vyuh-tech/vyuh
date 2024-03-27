import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vyuh_core/runtime/platform/error_view.dart';
import 'package:vyuh_core/vyuh_core.dart';

final defaultPlatformWidgetBuilder = PlatformWidgetBuilder(
    appBuilder: (platform) {
      return MaterialApp.router(
        theme: ThemeData.light(useMaterial3: true),
        routerConfig: platform.router,
      );
    },
    appLoader: () => const _DefaultRouteLoader(
          delay: Duration(milliseconds: 0),
          backgroundColor: Colors.black,
          progressColor: Colors.white,
        ),
    routeLoader: ([_, __]) => const _DefaultRouteLoader(
          delay: Duration(milliseconds: 0),
          backgroundColor: Colors.white30,
        ),
    contentLoader: () => const Center(
            child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        )),
    imagePlaceholder: ({width, height}) => Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(color: Colors.black12),
          padding: const EdgeInsets.all(20.0),
          child: const Icon(
            Icons.image_not_supported_rounded,
            color: Colors.grey,
            size: 32,
          ),
        ),
    errorView: ({
      required title,
      retryLabel,
      onRetry,
      subtitle,
      error,
      showRestart = true,
    }) =>
        ErrorView(
          title: title,
          subtitle: subtitle,
          error: error,
          retryLabel: retryLabel,
          onRetry: onRetry,
        ),
    routeErrorView: ({
      required title,
      onRetry,
      retryLabel,
      subtitle,
      error,
    }) =>
        ErrorViewScaffold(
          title: title,
          subtitle: subtitle,
          error: error,
          onRetry: onRetry,
          retryLabel: retryLabel,
          showRestart: true,
        ));

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
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: LinearProgressIndicator(
            backgroundColor: progressColor.withOpacity(0.25),
            color: progressColor,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: _isTimerDone ? body : null,
    );
  }
}
