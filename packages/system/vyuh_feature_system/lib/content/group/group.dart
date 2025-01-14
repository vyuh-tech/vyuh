import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/content/group/default_layout.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

export 'grid_layout.dart';

part 'group.g.dart';

/// A group content item that can contain and organize multiple content items.
///
/// Groups can:
/// * Display a collection of content items in various layouts
/// * Have an optional title and description
/// * Be used inside portable text blocks
/// * Support different layouts (grid, list, carousel)
///
/// Example:
/// ```dart
/// final group = Group(
///   title: 'My Collection',
///   description: 'A collection of cards',
///   items: [
///     Card(title: 'First Card', description: 'Card 1'),
///     Card(title: 'Second Card', description: 'Card 2'),
///   ],
///   layout: GridGroupLayout(columns: 2),
/// );
/// ```
///
/// Groups can be used:
/// * To organize related content items
/// * Create grid or list layouts
/// * Build carousels or slideshows
/// * Inside portable text blocks
@JsonSerializable()
class Group extends ContentItem implements PortableBlockItem, ContainerItem {
  static const schemaName = 'vyuh.group';

  static final typeDescriptor = TypeDescriptor(
    schemaType: Group.schemaName,
    title: 'Group',
    fromJson: Group.fromJson,
    preview: () => Group(items: [
      Card(
        title: 'One',
        description: 'The first card',
        imageUrl: Uri.parse('https://picsum.photos/200/150'),
      ),
      Card(
        title: 'Two',
        description: 'The second card',
        imageUrl: Uri.parse('https://picsum.photos/200/150'),
      ),
      Card(
        title: 'Three',
        description: 'The third card',
        imageUrl: Uri.parse('https://picsum.photos/200/150'),
      ),
    ]),
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

/// Descriptor for configuring group content type in the system.
///
/// Allows configuring:
/// * Available layouts for groups (default, grid, list, carousel)
/// * Custom layouts for specific use cases
///
/// Example:
/// ```dart
/// final descriptor = GroupDescriptor(
///   layouts: [
///     DefaultGroupLayout.typeDescriptor,
///     GridGroupLayout.typeDescriptor,
///     CarouselGroupLayout.typeDescriptor,
///   ],
/// );
/// ```
class GroupDescriptor extends ContentDescriptor {
  GroupDescriptor({super.layouts})
      : super(schemaType: Group.schemaName, title: 'Group');
}

/// A conditional layout for groups that adapts based on specified conditions.
///
/// Allows defining different layouts for groups based on conditions like:
/// * Screen size (single column vs multi-column)
/// * Theme mode (different spacing/padding)
/// * Content count (grid vs list)
///
/// Example:
/// ```dart
/// final layout = GroupConditionalLayout(
///   cases: [
///     LayoutCaseItem(
///       value: 'mobile',
///       item: ListGroupLayout(),
///     ),
///     LayoutCaseItem(
///       value: 'desktop',
///       item: GridGroupLayout(columns: 3),
///     ),
///   ],
///   defaultCase: 'desktop',
///   condition: ScreenSize(),
/// );
/// ```
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
