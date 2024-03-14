import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

final class DefaultContentPlugin extends ContentPlugin {
  late final ContentExtensionBuilder _extensionBuilder;

  DefaultContentPlugin({required super.provider})
      : super(
          name: 'vyuh.plugin.content',
          title: 'Content Plugin',
        );

  @override
  Map<Type, Map<String, FromJsonConverter>> get typeRegistry =>
      _extensionBuilder.getTypeRegistry();

  @override
  Widget buildContent(BuildContext context, ContentItem content) {
    final builder = _extensionBuilder.getContentBuilder(content.schemaType);

    assert(builder != null,
        'Failed to retrieve builder for schemaType: ${content.schemaType}');

    final builtContent = builder?.build(context, content);

    assert(builtContent != null,
        'Failed to build content for schemaType: ${content.schemaType}');

    return builtContent ?? const SizedBox.shrink();
  }

  @override
  Widget buildRoute(BuildContext context, {Uri? url, String? routeId}) =>
      RouteFutureBuilder(
        url: url,
        routeId: routeId,
        fetchRoute: ({path, routeId}) => provider
            .fetchRoute(path: path, routeId: routeId)
            .then((value) async {
          final finalRoute = await value?.init();
          return finalRoute;
        }),
        buildContent: buildContent,
      );

  @override
  T? fromJson<T>(Map<String, dynamic> json) {
    final type = provider.schemaType(json);
    return _extensionBuilder.fromJson<T>(type, json);
  }

  @override
  register<T>(TypeDescriptor<T> descriptor) =>
      _extensionBuilder.register<T>(descriptor);

  @override
  isRegistered<T>(TypeDescriptor<T> descriptor) =>
      _extensionBuilder.isRegistered<T>(descriptor);

  @override
  Future<void> dispose() => provider.dispose();

  @override
  Future<void> init() {
    // Create a one-time reaction to clear the maps whenever the framework is restarted
    when((_) => vyuh.tracker.currentState.value == InitState.notStarted, () {
      _extensionBuilder.reset();
    });

    return provider.init();
  }

  @override
  void setup(List<FeatureDescriptor> features) {
    final extBuilders = features
        .expand((element) => element.extensionBuilders ?? [])
        .whereType<ContentExtensionBuilder>();

    assert(
        extBuilders.length == 1,
        'For the $runtimeType to work, there must be only one $ContentExtensionBuilder in your extension builders. '
        'However, we found ${extBuilders.length}.');

    _extensionBuilder = extBuilders.first;
  }
}
