import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'card.g.dart';

@JsonSerializable()
class Card extends ContentItem implements PortableBlockItem {
  static const schemaName = 'vyuh.card';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Card',
    fromJson: Card.fromJson,
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

class CardDescriptor extends ContentDescriptor {
  CardDescriptor({super.layouts})
      : super(schemaType: Card.schemaName, title: 'Card');
}

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
