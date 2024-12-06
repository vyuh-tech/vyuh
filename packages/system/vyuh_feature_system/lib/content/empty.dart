import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'empty.g.dart';

const empty = SizedBox.shrink();

@JsonSerializable()
class Empty extends ContentItem {
  static const schemaName = 'vyuh.empty';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Empty',
    fromJson: Empty.fromJson,
  );
  static final contentBuilder = ContentBuilder(
    content: Empty.typeDescriptor,
    defaultLayout: DefaultEmptyLayout(),
    defaultLayoutDescriptor: DefaultEmptyLayout.typeDescriptor,
  );

  Empty({
    super.layout,
    super.modifiers,
  }) : super(schemaType: Empty.schemaName);

  factory Empty.fromJson(Map<String, dynamic> json) => _$EmptyFromJson(json);
}

class EmptyDescriptor extends ContentDescriptor {
  EmptyDescriptor()
      : super(schemaType: Empty.schemaName, title: 'Empty', layouts: const []);
}

final class DefaultEmptyLayout extends LayoutConfiguration<Empty> {
  static const schemaName = '${Empty.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Empty Layout',
    fromJson: DefaultEmptyLayout.fromJson,
  );

  DefaultEmptyLayout() : super(schemaType: schemaName);

  factory DefaultEmptyLayout.fromJson(Map<String, dynamic> json) =>
      DefaultEmptyLayout();

  @override
  Widget build(BuildContext context, Empty content) {
    return empty;
  }
}
