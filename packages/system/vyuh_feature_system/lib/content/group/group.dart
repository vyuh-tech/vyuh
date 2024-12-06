import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/content/group/default_layout.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

export 'grid_layout.dart';

part 'group.g.dart';

@JsonSerializable()
class Group extends ContentItem implements PortableBlockItem, ContainerItem {
  static const schemaName = 'vyuh.group';

  static final typeDescriptor = TypeDescriptor(
    schemaType: Group.schemaName,
    title: 'Group',
    fromJson: Group.fromJson,
  );

  static final contentBuilder = ContentBuilder(
    content: Group.typeDescriptor,
    defaultLayout: DefaultGroupLayout(),
    defaultLayoutDescriptor: DefaultGroupLayout.typeDescriptor,
  );

  @override
  String get blockType => schemaName;

  final String? title;

  final String? description;

  @JsonKey(defaultValue: [])
  final List<ContentItem> items;

  Group({
    this.title,
    this.description,
    required this.items,
    super.layout,
    super.modifiers,
  }) : super(schemaType: Group.schemaName) {
    setParent(items);
  }

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}

class GroupDescriptor extends ContentDescriptor {
  GroupDescriptor({super.layouts})
      : super(schemaType: Group.schemaName, title: 'Group');
}

@JsonSerializable()
final class GroupConditionalLayout extends ConditionalLayout<Group> {
  static const schemaName = '${Group.schemaName}.layout.conditional';

  static final typeDescriptor = TypeDescriptor(
    schemaType: GroupConditionalLayout.schemaName,
    title: 'Group Conditional Layout',
    fromJson: GroupConditionalLayout.fromJson,
  );

  GroupConditionalLayout({
    required super.cases,
    required super.defaultCase,
    required super.condition,
  }) : super(schemaType: schemaName);

  factory GroupConditionalLayout.fromJson(Map<String, dynamic> json) =>
      _$GroupConditionalLayoutFromJson(json);
}
