import 'package:content_widget_demo/example.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;

final class RouteExample extends ExampleWidget {
  const RouteExample({super.key})
      : super(
          title: 'Complex Route',
          description: 'Render a complex Route document from the CMS',
        );

  @override
  Widget build(BuildContext context) {
    return VyuhContentWidget(
      query: '''
*[_type == "vyuh.route" && path == \$path][0]{
  ...,
  category->,
  regions[] {
    "identifier": region->identifier,
    "title": region->title,
    items
  },
}
''',
      queryParams: {'path': '/misc/text'},
      fromJson: system.Route.fromJson,
      builder: (context, route) =>
          VyuhContentBinding.content.buildContent(context, route),
    );
  }
}
