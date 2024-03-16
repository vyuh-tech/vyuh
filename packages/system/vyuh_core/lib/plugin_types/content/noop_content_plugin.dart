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
    return const SizedBox.shrink();
  }

  @override
  Widget buildRoute(BuildContext context, {Uri? url, String? routeId}) {
    return const SizedBox.shrink();
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
  Map<Type, Map<String, FromJsonConverter>> get typeRegistry => {};
}
