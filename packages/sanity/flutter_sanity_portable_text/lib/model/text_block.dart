import 'package:json_annotation/json_annotation.dart';
import 'package:nanoid/nanoid.dart';

import '../flutter_sanity_portable_text.dart';

part 'text_block.g.dart';

/// The PortableBlockItem interface provides a way to handle different
/// types of 'Block Items' within the Portable Text.
/// Every such block item is identified by the [blockType] property.
abstract interface class PortableBlockItem {
  /// A unique string-name for the block type.
  String get blockType;
}

/// Identifies the type of list-item within the block.
enum ListItemType { bullet, square, number }

/// A block of text within the Portable Text document. This is the most common and popular block item
/// within the Portable Text instance. Most of the fields are based on the specification for Portable Text,
/// which can be seen here: https://www.portabletext.org/
@JsonSerializable()
@MarkDefsConverter()
class TextBlockItem implements PortableBlockItem {
  static const schemaName = 'block';

  @override
  String get blockType => schemaName;

  @JsonKey(name: '_key')
  final String key;

  /// Children is an array of spans or custom inline types that is contained within a block.
  final List<Span> children;

  /// Mark definitions is an array of objects with a key, type and some data.
  /// Mark definitions are tied to spans by adding the referring _key in the marks array.
  final List<MarkDef> markDefs;

  /// Style typically describes a visual property for the whole block. Typical values
  /// are "h1", "h2", "h3", "normal", "blockquote", etc.
  final String style;

  /// A block can be given the property listItem with a value that describes
  /// which kind of list it is. Typically bullet, number, square and so on.
  /// The list position is derived from the position the block has in the array
  /// and surrounding list items on the same level.
  final ListItemType? listItem;

  /// This specifies the visual nesting level of the block.
  /// Nested blocks are indented on the left.
  final int? level;

  /// An internal field to track the index of the list item
  int? listItemIndex;

  TextBlockItem({
    String? key,
    this.children = const <Span>[],
    this.style = 'normal',
    this.markDefs = const <MarkDef>[],
    this.listItem,
    this.level,
  }) : key = key ?? nanoid();

  factory TextBlockItem.fromJson(final Map<String, dynamic> json) =>
      _$TextBlockItemFromJson(json);
}

/// A Span is the standard way to express inline text within a block
@JsonSerializable()
class Span {
  static const schemaName = 'span';

  @JsonKey(name: '_type')
  final String type;

  /// Contains the text content of the span
  final String text;

  /// Set of annotations and decorations to apply to this span of text.
  /// Custom annotations are also allowed.
  final List<String> marks;

  Span({
    this.type = Span.schemaName,
    this.text = '',
    this.marks = const <String>[],
  });

  factory Span.fromJson(final Map<String, dynamic> json) =>
      _$SpanFromJson(json);
}
