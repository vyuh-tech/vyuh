import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

final class ContentExtensionDescriptor extends ExtensionDescriptor {
  ContentExtensionDescriptor({
    this.contents,
    this.contentModifiers,
    this.contentBuilders,
    this.actions,
    this.conditions,
    this.routeTypes,
  }) : super(title: 'Content Extension');

  final List<ContentDescriptor>? contents;
  final List<TypeDescriptor<ContentModifierConfiguration>>? contentModifiers;
  final List<ContentBuilder>? contentBuilders;
  final List<TypeDescriptor<ActionConfiguration>>? actions;
  final List<TypeDescriptor<ConditionConfiguration>>? conditions;
  final List<TypeDescriptor<RouteTypeConfiguration>>? routeTypes;
}
