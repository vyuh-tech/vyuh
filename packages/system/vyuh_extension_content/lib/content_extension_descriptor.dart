import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

final class ContentExtensionDescriptor extends ExtensionDescriptor {
  final List<ContentDescriptor>? contents;

  final List<TypeDescriptor<ContentModifierConfiguration>>? contentModifiers;
  final List<ContentBuilder>? contentBuilders;
  final List<TypeDescriptor<ActionConfiguration>>? actions;
  final List<TypeDescriptor<ConditionConfiguration>>? conditions;
  final List<TypeDescriptor<RouteTypeConfiguration>>? routeTypes;

  ContentExtensionDescriptor({
    this.contents,
    this.contentModifiers,
    this.contentBuilders,
    this.actions,
    this.conditions,
    this.routeTypes,
  }) : super(title: 'Content Extension');

  @override
  onSourceFeatureUpdated() {
    for (final td in actions ?? <TypeDescriptor<ActionConfiguration>>[]) {
      td.setSourceFeature(sourceFeature);
    }

    for (final td in conditions ?? <TypeDescriptor<ConditionConfiguration>>[]) {
      td.setSourceFeature(sourceFeature);
    }

    for (final td in routeTypes ?? <TypeDescriptor<RouteTypeConfiguration>>[]) {
      td.setSourceFeature(sourceFeature);
    }

    for (final td in contentModifiers ??
        <TypeDescriptor<ContentModifierConfiguration>>[]) {
      td.setSourceFeature(sourceFeature);
    }

    for (final td in contentBuilders ?? <ContentBuilder>[]) {
      td.setSourceFeature(sourceFeature);
    }

    for (final td in contents ?? <ContentDescriptor>[]) {
      td.setSourceFeature(sourceFeature);
    }
  }
}
