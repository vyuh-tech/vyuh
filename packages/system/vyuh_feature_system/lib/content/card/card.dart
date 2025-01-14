import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'card.g.dart';

/// A card content item that can display various types of content in a card format.
///
/// Cards can include:
/// * Title and description
/// * Images (via URL or ImageReference)
/// * Rich text content (PortableText)
/// * Up to three actions (primary, secondary, tertiary) that can be configured
///   with multiple action configurations
///
/// Example:
/// ```dart
/// final card = Card(
///   title: 'My Card',
///   description: 'Card description',
///   imageUrl: Uri.parse('https://example.com/image.jpg'),
///   action: Action(
///     configurations: [
///       NavigationAction(
///         linkType: LinkType.route,
///         route: ObjectReference('route-id'),
///       ),
///       DelayAction(duration: Duration(milliseconds: 300)),
///     ],
///   ),
/// );
/// ```
///
/// Cards can be used:
/// * As standalone content items
/// * Within groups or lists
/// * Inside portable text blocks
@JsonSerializable()
class Card extends ContentItem implements PortableBlockItem {
  static const schemaName = 'vyuh.card';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Card',
    fromJson: Card.fromJson,
    preview: () => Card(
      title: 'Title for the Card',
      description: 'A description for the card',
      imageUrl: Uri.parse('https://picsum.photos/300/200'),
    ),
  );
  static final contentBuilder = ContentBuilder(
    content: Card.typeDescriptor,
    defaultLayout: DefaultCardLayout(title: 'Default'),
    defaultLayoutDescriptor: DefaultCardLayout.typeDescriptor,
  );

  static final descriptor = ContentDescriptor.createDefault(
    schemaType: Card.schemaName,
    title: 'Card Descriptor',
  );

  // Required to support Blocks inside Portable Text
  @override
  String get blockType => schemaName;

  final String? title;
  final String? description;
  final ImageReference? image;
  final Uri? imageUrl;
  final PortableTextContent? content;

  final Action? action;
  final Action? secondaryAction;
  final Action? tertiaryAction;

  Card({
    required this.title,
    required this.description,
    this.content,
    this.image,
    this.imageUrl,
    this.action,
    this.secondaryAction,
    this.tertiaryAction,
    super.layout,
    super.modifiers,
  }) : super(schemaType: Card.schemaName) {
    setParent([
      if (content != null) content!,
    ]);
  }

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);
}

/// Descriptor for configuring card content type in the system.
///
/// Allows configuring:
/// * Available layouts for cards (default, list item, button)
/// * Custom layouts for specific use cases
///
/// Example:
/// ```dart
/// final descriptor = CardDescriptor(
///   layouts: [
///     DefaultCardLayout.typeDescriptor,
///     ListItemCardLayout.typeDescriptor,
///   ],
/// );
/// ```
class CardDescriptor extends ContentDescriptor {
  CardDescriptor({super.layouts})
      : super(schemaType: Card.schemaName, title: 'Card');
}

/// A conditional layout for cards that adapts based on specified conditions.
///
/// Allows defining different layouts for cards based on conditions like:
/// * Screen size (compact vs expanded layouts)
/// * Theme mode (light/dark specific layouts)
/// * Content properties (image presence, action count)
///
/// Example:
/// ```dart
/// final layout = CardConditionalLayout(
///   cases: [
///     LayoutCaseItem(
///       value: 'mobile',
///       item: CompactCardLayout(),
///     ),
///     LayoutCaseItem(
///       value: 'desktop',
///       item: ExpandedCardLayout(),
///     ),
///   ],
///   defaultCase: 'desktop',
///   condition: ScreenSize(),
/// );
/// ```
@JsonSerializable()
final class CardConditionalLayout extends ConditionalLayout<Card> {
  static const schemaName = '${Card.schemaName}.layout.conditional';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Card Conditional Layout',
    fromJson: CardConditionalLayout.fromJson,
  );

  CardConditionalLayout({
    required super.cases,
    required super.defaultCase,
    required super.condition,
  }) : super(schemaType: schemaName);

  factory CardConditionalLayout.fromJson(Map<String, dynamic> json) =>
      _$CardConditionalLayoutFromJson(json);
}
