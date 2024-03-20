import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

class RouteContainer extends StatefulWidget {
  final RouteBase content;

  final Widget child;

  const RouteContainer({super.key, required this.content, required this.child});

  @override
  State<RouteContainer> createState() => _RouteContainerState();
}

class _RouteContainerState extends State<RouteContainer> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    super.dispose();

    unawaited(widget.content.dispose());
  }
}
