import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vyuh_core/runtime/platform/powered_by_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'default_route_loader.dart';
part 'error_view.dart';

final defaultPlatformWidgetBuilder = PlatformWidgetBuilder(
    appBuilder: (platform) {
      return MaterialApp.router(
        theme: ThemeData.light(useMaterial3: true),
        routerConfig: platform.router.instance,
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
          child: Column(
            children: [
              RepaintBoundary(child: CircularProgressIndicator()),
              PoweredByWidget(),
            ],
          ),
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
        _ErrorView(
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
        _ErrorViewScaffold(
          title: title,
          subtitle: subtitle,
          error: error,
          onRetry: onRetry,
          retryLabel: retryLabel,
          showRestart: true,
        ));
