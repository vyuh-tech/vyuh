import 'package:flutter/material.dart';

class RouteBuilderProxy extends InheritedWidget {
  final Future<void> Function() onRefresh;

  const RouteBuilderProxy({
    super.key,
    required super.child,
    required this.onRefresh,
  });

  Future<void> refresh() => onRefresh();

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
