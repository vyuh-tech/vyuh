import 'package:collection/collection.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

final class ContentExtensionBuilder extends ExtensionBuilder {
  final Map<Type, Map<String, TypeDescriptor>> _typeConverterMap = {};
  final Map<String, ContentBuilder> _contentBuilderMap = {};

  ContentExtensionBuilder()
      : super(
          extensionType: ContentExtensionDescriptor,
          title: 'Content Extension Builder',
        );

  Map<Type, Map<String, TypeDescriptor>> typeRegistry() {
    return Map<Type, Map<String, TypeDescriptor>>.unmodifiable(
        _typeConverterMap);
  }

  ContentBuilder<ContentItem>? contentBuilder(String schemaType) {
    return _contentBuilderMap[schemaType];
  }

  List<ContentBuilder> contentBuilders() =>
      List.unmodifiable(_contentBuilderMap.values);

  @override
  Future<void> onInit(List<ExtensionDescriptor> extensions) async {
    // Initialize unknown placeholder factory to handle missing type registrations
    initializeUnknownPlaceholderFactory();

    // Attach to the Content Plugin before setting up the Content{Builder,Descriptor}s
    VyuhBinding.instance.content.attach(this);

    _build(extensions);
  }

  void _build(List<ExtensionDescriptor> extensions) {
    final descriptors = extensions.cast<ContentExtensionDescriptor>();

    final contentBuilders = descriptors
        .expand((element) => element.contentBuilders ?? <ContentBuilder>[])
        .groupListsBy((element) => element.content.schemaType);

    final contents = descriptors
        .expand((element) => element.contents ?? <ContentDescriptor>[])
        .groupListsBy((element) => element.schemaType);

    // Collect the builders
    for (final entry in contentBuilders.entries) {
      assert(entry.value.length == 1,
          'There can be only one ContentBuilder for a content-type. We found ${entry.value.length} for ${entry.key}');

      _contentBuilderMap[entry.key] = entry.value.first;
    }

    // Ensure every ContentDescriptor has a ContentBuilder
    for (final entry in contents.entries) {
      final schemaType = entry.key;
      final builder = _contentBuilderMap[schemaType];

      assert(builder != null,
          'Missing ContentBuilder for ContentDescriptor of schemaType: $schemaType');
    }

    // Setup the builders
    for (final entry in _contentBuilderMap.entries) {
      final schemaType = entry.key;
      final builder = entry.value;
      registerBuilder(builder, descriptors: contents[schemaType] ?? []);
    }

    _initTypeRegistrations(
      descriptors,
      (feature) =>
          feature.contentModifiers ??
          <TypeDescriptor<ContentModifierConfiguration>>[],
    );

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

  @override
  Future<void> onDispose() async {
    _typeConverterMap.clear();
    _contentBuilderMap.clear();
  }

  T? fromJson<T>(String typeName, Map<String, dynamic> json) {
    return _typeConverterMap[T]?[typeName]?.fromJson.call(json);
  }

  void register<T>(TypeDescriptor<T> descriptor) {
    _typeConverterMap.putIfAbsent(T, () => {});

    final hasKey = _typeConverterMap[T]!.containsKey(descriptor.schemaType);
    if (hasKey) {
      VyuhBinding.instance.log.warn(
          'A duplicate schemaType: ${descriptor.schemaType} is being registered.');
    }

    _typeConverterMap[T]![descriptor.schemaType] = descriptor;
  }

  bool isRegistered<T>(String schemaType) {
    return _typeConverterMap[T]?.containsKey(schemaType) == true;
  }

  /// Register a ContentBuilder directly
  /// This allows other plugins to register content builders programmatically
  void registerBuilder(ContentBuilder builder,
      {List<ContentDescriptor>? descriptors = const []}) {
    final schemaType = builder.content.schemaType;

    if (_contentBuilderMap.containsKey(schemaType)) {
      VyuhBinding.instance.log.warn(
        'ContentBuilder for schemaType: $schemaType is already registered. Overriding.',
      );
    }

    _contentBuilderMap[schemaType] = builder;

    final matchingDescriptors = descriptors
            ?.where((element) => element.schemaType == schemaType)
            .toList(growable: false) ??
        [];

    builder.init(matchingDescriptors);

    VyuhBinding.instance.log.info(
      'Registered ContentBuilder for schemaType: $schemaType',
    );
  }

  void _initTypeRegistrations<T>(List<ContentExtensionDescriptor> descriptors,
      List<TypeDescriptor<T>> Function(ContentExtensionDescriptor feature) fn) {
    descriptors.expand((element) => fn(element)).forEach((element) {
      register<T>(element);
    });
  }
}
