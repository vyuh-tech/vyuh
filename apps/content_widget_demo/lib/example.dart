import 'package:content_widget_demo/examples/conferences.dart';
import 'package:content_widget_demo/examples/custom_widget.dart';
import 'package:content_widget_demo/examples/route.dart';
import 'package:flutter/material.dart';

import 'examples/hello_world.dart';

final class Example {
  final String title;
  final String description;
  final Widget Function(BuildContext) builder;

  Example({
    required this.title,
    required this.description,
    required this.builder,
  });
}

final allExamples = [
  helloWorld,
  conferences,
  customWidget,
  route,
];
