import 'package:collection/collection.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

final class ContentExtensionBuilder extends FeatureExtensionBuilder {
  final Map<Type, Map<String, FromJsonConverter>> _typeConverterMap = {};
  final Map<String, ContentBuilder> _contentBuilderMap = {};

  ContentExtensionBuilder()
      : super(
          extensionType: ContentExtensionDescriptor,
          title: 'Content Extension Builder',
        );

  @override
  void build(List<FeatureExtensionDescriptor> extensions) {
    final descriptors = extensions.cast<ContentExtensionDescriptor>();

    final contentBuilders = descriptors
        .expand((element) => element.contentBuilders ?? <ContentBuilder>[])
        .groupListsBy((element) => element.content.schemaType);

    final contents = descriptors
        .expand((element) => element.contents ?? <ContentDescriptor>[])
        .groupListsBy((element) => element.schemaType);

    for (final entry in contentBuilders.entries) {
      assert(entry.value.length == 1,
          'There can be only one ContentBuilder for a content-type. We found ${entry.value.length} for ${entry.key}');

      _contentBuilderMap[entry.key] = entry.value.first;
    }

    for (final entry in contents.entries) {
      final schemaType = entry.key;
      final descriptors = entry.value;
      final builder = _contentBuilderMap[schemaType];

      assert(builder != null,
          'Missing ContentBuilder for ContentDescriptor of schemaType: $schemaType');

      builder?.init(descriptors);
    }

    _initTypeRegistrations(
      descriptors,
      (feature) => feature.actions ?? <TypeDescriptor<ActionConfiguration>>[],
    );

    _initTypeRegistrations(
      descriptors,
      (feature) =>
          feature.conditions ?? <TypeDescriptor<ConditionConfiguration>>[],
    );
  }

  Map<Type, Map<String, FromJsonConverter>> getTypeRegistry() {
    return Map<Type, Map<String, FromJsonConverter>>.unmodifiable(
        _typeConverterMap);
  }

  ContentBuilder<ContentItem>? getContentBuilder(String schemaType) {
    return _contentBuilderMap[schemaType];
  }

  void reset() {
    _typeConverterMap.clear();
    _contentBuilderMap.clear();
  }

  T? fromJson<T>(String typeName, Map<String, dynamic> json) {
    return _typeConverterMap[T]?[typeName]?.call(json);
  }

  register<T>(TypeDescriptor<T> descriptor) {
    _typeConverterMap.putIfAbsent(T, () => {});

    final hasKey = _typeConverterMap[T]!.containsKey(descriptor.schemaType);
    assert(hasKey == false,
        'A duplicate schemaType: ${descriptor.schemaType} is being registered.');

    _typeConverterMap[T]![descriptor.schemaType] = descriptor.fromJson;
  }

  isRegistered<T>(TypeDescriptor<T> descriptor) {
    final hasKey =
        _typeConverterMap[T]?.containsKey(descriptor.schemaType) == true;

    return hasKey;
  }

  void _initTypeRegistrations<T>(List<ContentExtensionDescriptor> descriptors,
      List<TypeDescriptor<T>> Function(ContentExtensionDescriptor feature) fn) {
    descriptors.expand((element) => fn(element)).forEach((element) {
      register<T>(element);
    });
  }
}