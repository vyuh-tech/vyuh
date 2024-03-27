import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart' as vx;
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/content/card/default_layout.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'card.g.dart';

@JsonSerializable()
class Card extends ContentItem implements PortableBlockItem {
  static const schemaName = 'vyuh.card';

  // Required to support Blocks inside Portable Text
  @override
  String get blockType => schemaName;

  final String? title;
  final String? description;
  final ImageReference? image;
  final Uri? imageUrl;
  final PortableTextContent? content;

  final vx.Action? action;
  final vx.Action? secondaryAction;
  final vx.Action? tertiaryAction;

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
  }) : super(schemaType: Card.schemaName) {
    setParent([
      if (content != null) content!,
    ]);
  }

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);
}

class CardDescriptor extends vx.ContentDescriptor {
  CardDescriptor({super.layouts})
      : super(schemaType: Card.schemaName, title: 'Card');
}

final class CardContentBuilder extends vx.ContentBuilder<Card> {
  CardContentBuilder()
      : super(
          content: TypeDescriptor(
              schemaType: Card.schemaName,
              title: 'Card',
              fromJson: Card.fromJson),
          defaultLayout: DefaultCardLayout(title: 'Default'),
          defaultLayoutDescriptor: DefaultCardLayout.typeDescriptor,
        );
}
