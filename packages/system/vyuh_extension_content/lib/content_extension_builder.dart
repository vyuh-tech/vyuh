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

  /// Register extensions from a lazily-loaded feature incrementally.
  ///
  /// Called after the initial [onInit] has already run. Uses the same
  /// registration primitives as [_build] but operates additively —
  /// only processes the new descriptors without clearing existing state.
  @override
  void registerLazy(ExtensionDescriptor descriptor) {
    if (descriptor is! ContentExtensionDescriptor) return;

    final ext = descriptor;

    // Track which content schemaTypes were newly registered via registerBuilder,
    // so we can skip them in the addDescriptors step below.
    final newlyRegistered = <String>{};

    // 1. Register NEW content builders (calls registerBuilder → init, same as _build)
    for (final builder in ext.contentBuilders ?? <ContentBuilder>[]) {
      final schemaType = builder.content.schemaType;

      if (_contentBuilderMap.containsKey(schemaType)) {
        // Existing builder — will be handled additively in step 2
        continue;
      }

      final matchingDescriptors = (ext.contents ?? [])
          .where((cd) => cd.schemaType == schemaType)
          .toList(growable: false);

      registerBuilder(builder, descriptors: matchingDescriptors);
      newlyRegistered.add(schemaType);
    }

    // 2. For EXISTING builders: additively register new descriptors.
    //    Uses addDescriptors() which adds layouts without clearing,
    //    and runs subclass-specific registration logic (same as init but additive).
    for (final content in ext.contents ?? <ContentDescriptor>[]) {
      final schemaType = content.schemaType;

      // Skip descriptors already processed by registerBuilder in step 1
      if (newlyRegistered.contains(schemaType)) continue;

      final existingBuilder = _contentBuilderMap[schemaType];
      if (existingBuilder == null) continue;

      existingBuilder.addDescriptors([content]);
    }

    // 3. Register extension-level type descriptors (same as _build's _initTypeRegistrations)
    for (final action
        in ext.actions ?? <TypeDescriptor<ActionConfiguration>>[]) {
      register<ActionConfiguration>(action);
    }

    for (final condition
        in ext.conditions ?? <TypeDescriptor<ConditionConfiguration>>[]) {
      register<ConditionConfiguration>(condition);
    }

    for (final modifier in ext.contentModifiers ??
        <TypeDescriptor<ContentModifierConfiguration>>[]) {
      register<ContentModifierConfiguration>(modifier);
    }
  }
}
