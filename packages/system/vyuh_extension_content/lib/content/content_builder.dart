import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

class ContentBuilder<T extends ContentItem> {
  final TypeDescriptor<T> content;
  final LayoutConfiguration<T> defaultLayout;
  final TypeDescriptor<LayoutConfiguration> defaultLayoutDescriptor;

  ContentBuilder({
    required this.content,
    required this.defaultLayout,
    required this.defaultLayoutDescriptor,
  });

  @mustCallSuper
  void init(List<ContentDescriptor> descriptors) {
    vyuh.content.register<ContentItem>(content);

    registerDescriptors<LayoutConfiguration>(descriptors.expand((element) =>
        element.layouts ?? <TypeDescriptor<LayoutConfiguration>>[]));

    // Default layout could be registered explicitly by the ContentItem,
    // in which case, we don't do it again.
    if (!vyuh.content
        .isRegistered<LayoutConfiguration>(defaultLayoutDescriptor)) {
      registerDescriptors<LayoutConfiguration>([defaultLayoutDescriptor]);
    }
  }

  @protected
  void registerDescriptors<U>(Iterable<TypeDescriptor<U>> descriptors,
      {bool checkUnique = false}) {
    for (var element in descriptors) {
      if (checkUnique && vyuh.content.isRegistered<U>(element)) {
        return;
      }

      vyuh.content.register<U>(element);
    }
  }

  Widget build(BuildContext context, T content) {
    var layout = content.getLayout();
    if (layout == null) {
      layout = defaultLayout;
      vyuh.log
          .debug('No layout found for ${content.schemaType}. Using default.');
    }

    try {
      return layout.build(context, content);
    } catch (e) {
      return vyuh.widgetBuilder.errorView(context,
          error: e,
          title: 'Failed to build layout',
          subtitle:
              'Layout: "${layout.schemaType}" for Content: "${content.schemaType}"');
    }
  }
}
