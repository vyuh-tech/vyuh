import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

class ContentBuilder<T extends ContentItem> {
  final TypeDescriptor<T> content;
  LayoutConfiguration<T> _defaultLayout;
  TypeDescriptor<LayoutConfiguration> _defaultLayoutDescriptor;

  LayoutConfiguration<T> get defaultLayout => _defaultLayout;
  TypeDescriptor<LayoutConfiguration> get defaultLayoutDescriptor =>
      _defaultLayoutDescriptor;

  ContentBuilder({
    required this.content,
    required LayoutConfiguration<T> defaultLayout,
    required TypeDescriptor<LayoutConfiguration> defaultLayoutDescriptor,
  })  : _defaultLayout = defaultLayout,
        _defaultLayoutDescriptor = defaultLayoutDescriptor;

  @mustCallSuper
  void init(List<ContentDescriptor> descriptors) {
    vyuh.content.register<ContentItem>(content);

    registerDescriptors<LayoutConfiguration>(descriptors.expand((element) =>
        element.layouts ?? <TypeDescriptor<LayoutConfiguration>>[]));

    // Default layout could be registered explicitly by the ContentItem,
    // in which case, we don't do it again.
    if (!vyuh.content
        .isRegistered<LayoutConfiguration>(defaultLayoutDescriptor.schemaType)) {
      registerDescriptors<LayoutConfiguration>([defaultLayoutDescriptor]);
    }
  }

  @protected
  void registerDescriptors<U>(Iterable<TypeDescriptor<U>> descriptors,
      {bool checkUnique = false}) {
    for (var element in descriptors) {
      if (checkUnique && vyuh.content.isRegistered<U>(element.schemaType)) {
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

    return layout.build(context, content);
  }

  setDefaultLayout(LayoutConfiguration<T> layout,
      {required FromJsonConverter<LayoutConfiguration> fromJson}) {
    _defaultLayout = layout;

    final currentLayoutSchemaType = _defaultLayoutDescriptor.schemaType;

    _defaultLayoutDescriptor = TypeDescriptor<LayoutConfiguration>(
      schemaType: currentLayoutSchemaType,
      fromJson: fromJson,
      title: 'Override Layout for ${content.schemaType}',
    );
    registerDescriptors<LayoutConfiguration>([_defaultLayoutDescriptor]);
  }
}
