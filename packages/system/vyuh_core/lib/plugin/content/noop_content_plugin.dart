import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

final messages = {
  'title': (_) => 'No Content Plugin',
  'error': (String arg) => '''
No content plugin configured to render $arg.
 
You have three options:
1. Configure one of the default ContentPlugin-s to render this content.
2. Create a custom ContentPlugin to render this content.
3. Configure a custom GoRoute to handle this path.
''',
};

final class NoOpContentPlugin extends ContentPlugin {
  NoOpContentPlugin()
      : super(
          provider: NoOpContentProvider(),
          name: 'vyuh.plugin.content.noop',
          title: 'No Op Content Plugin',
        );

  @override
  Widget buildContent(BuildContext context, ContentItem content) {
    return vyuh.widgetBuilder.errorView(
      context,
      title: messages['title']!(''),
      error: messages['error']!(content.schemaType),
    );
  }

  @override
  Widget buildRoute(BuildContext context, {Uri? url, String? routeId}) {
    final routeDetail = [
      if (url != null) 'Url: $url',
      if (routeId != null) 'RouteId: $routeId',
    ].join('');
    return vyuh.widgetBuilder.routeErrorView(
      context,
      title: messages['title']!(''),
      error: messages['error']!(routeDetail),
    );
  }

  @override
  Future<void> dispose() async {}

  @override
  Future<void> init() async {}

  @override
  isRegistered<T>(TypeDescriptor<T> descriptor) {
    return false;
  }

  @override
  register<T>(TypeDescriptor<T> descriptor) {}

  @override
  void setup(List<FeatureDescriptor> features) {}

  @override
  T? fromJson<T>(Map<String, dynamic> json) {
    return null;
  }

  @override
  Map<Type, Map<String, TypeDescriptor>> get typeRegistry => {};
}
