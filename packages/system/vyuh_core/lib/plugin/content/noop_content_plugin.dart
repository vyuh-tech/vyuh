import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

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
        title: 'No Content Plugin',
        subtitle:
            'No content plugin is available to render ${content.schemaType}.');
  }

  @override
  Widget buildRoute(BuildContext context, {Uri? url, String? routeId}) {
    final routeDetail = [
      if (url != null) 'Url: $url',
      if (routeId != null) 'RouteId: $routeId',
    ].join('');
    return vyuh.widgetBuilder.routeErrorView(
        title: 'No Content Plugin',
        subtitle: 'No content plugin is available to render $routeDetail.');
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
