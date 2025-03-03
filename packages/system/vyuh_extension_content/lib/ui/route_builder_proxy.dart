import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RouteBuilderProxy extends InheritedWidget {
  final Future<void> Function() _onRefresh;

  const RouteBuilderProxy({
    super.key,
    required super.child,
    required Future<void> Function() onRefresh,
  }) : _onRefresh = onRefresh;

  Future<void> refresh() => _onRefresh();

  @override
  bool updateShouldNotify(covariant RouteBuilderProxy oldWidget) {
    return oldWidget != this;
  }

  static RouteBuilderProxy? of(BuildContext context) {
    final proxy = context.getInheritedWidgetOfExactType<RouteBuilderProxy>();

    assert(proxy != null, 'RouteBuilderProxy is not available in your tree');

    return proxy;
  }
}

/// Works in conjunction with the RouteBuilderProxy to trigger refresh on a Route
final class RouteContentWithRefresh extends StatelessWidget {
  final Widget child;

  const RouteContentWithRefresh({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: kDebugMode
          ? Stack(
              children: [
                Positioned.fill(child: child),
                Positioned(
                  left: 5,
                  bottom: MediaQuery.of(context).viewPadding.bottom,
                  child: IconButton.filledTonal(
                    visualDensity: VisualDensity.compact,
                    mouseCursor: SystemMouseCursors.click,
                    icon: const Icon(Icons.refresh),
                    iconSize: 16,
                    onPressed: () {
                      RouteBuilderProxy.of(context)?.refresh();
                    },
                  ),
                )
              ],
            )
          : child,
    );
  }
}
