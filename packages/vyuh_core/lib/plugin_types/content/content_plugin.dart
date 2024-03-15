import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

abstract base class ContentPlugin extends Plugin {
  final ContentProvider provider;

  ContentPlugin({
    required this.provider,
    required super.name,
    required super.title,
  }) : super(pluginType: PluginType.content);

  Map<Type, Map<String, FromJsonConverter>> get typeRegistry;

  Widget buildContent(BuildContext context, ContentItem content);

  Widget buildRoute(BuildContext context, {Uri? url, String? routeId});

  void setup(List<FeatureDescriptor> features);

  T? fromJson<T>(Map<String, dynamic> json);

  register<T>(TypeDescriptor<T> descriptor);

  isRegistered<T>(TypeDescriptor<T> descriptor);
}
