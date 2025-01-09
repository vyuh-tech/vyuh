import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

class ContentBuilder<T extends ContentItem> {
  final TypeDescriptor<T> content;
  LayoutConfiguration<T> _defaultLayout;
  TypeDescriptor<LayoutConfiguration<T>> _defaultLayoutDescriptor;

  LayoutConfiguration<T> get defaultLayout => _defaultLayout;
  TypeDescriptor<LayoutConfiguration<T>> get defaultLayoutDescriptor =>
      _defaultLayoutDescriptor;

  final List<TypeDescriptor<LayoutConfiguration>> _layouts = [];
  List<TypeDescriptor<LayoutConfiguration>> get layouts => _layouts;

  String? _sourceFeature;
  String? get sourceFeature => _sourceFeature;

  setSourceFeature(String? featureName) {
    _sourceFeature = featureName;

    defaultLayoutDescriptor.setSourceFeature(featureName);
  }

  ContentBuilder({
    required this.content,
    required LayoutConfiguration<T> defaultLayout,
    required TypeDescriptor<LayoutConfiguration<T>> defaultLayoutDescriptor,
  })  : _defaultLayout = defaultLayout,
        _defaultLayoutDescriptor = defaultLayoutDescriptor;

  @mustCallSuper
  void init(List<ContentDescriptor> descriptors) {
    vyuh.content.register<ContentItem>(content);

    final userLayouts = descriptors.expand((element) =>
        element.layouts ?? <TypeDescriptor<LayoutConfiguration>>[]);
    final layouts = <TypeDescriptor<LayoutConfiguration>>{
      defaultLayoutDescriptor,
      ...userLayouts,
    }.toList(growable: false);

    _layouts
      ..clear()
      ..addAll(layouts);

    registerDescriptors<LayoutConfiguration>(layouts);
  }

  @protected
  void registerDescriptors<U>(Iterable<TypeDescriptor<U>> descriptors,
      {bool checkUnique = false}) {
    for (var element in descriptors) {
      if (checkUnique && vyuh.content.isRegistered<U>(element.schemaType)) {
        continue;
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

  setDefaultLayout(
    LayoutConfiguration<T> layout, {
    required FromJsonConverter<LayoutConfiguration<T>> fromJson,
    String? sourceFeatureName,
  }) {
    _defaultLayout = layout;

    final currentLayoutSchemaType = _defaultLayoutDescriptor.schemaType;

    _defaultLayoutDescriptor = TypeDescriptor<LayoutConfiguration<T>>(
      schemaType: currentLayoutSchemaType,
      fromJson: fromJson,
      title: 'Override Layout for ${content.schemaType}',
    );
    _defaultLayoutDescriptor.setSourceFeature(sourceFeatureName);

    registerDescriptors<LayoutConfiguration>([_defaultLayoutDescriptor]);

    _layouts.removeWhere((td) => td.schemaType == currentLayoutSchemaType);
    _layouts.insert(0, _defaultLayoutDescriptor);
  }
}
