import 'package:flutter/material.dart' as f;
import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'divider.g.dart';

@JsonSerializable()
class Divider extends ContentItem implements PortableBlockItem {
  static const schemaName = 'vyuh.divider';

  final double? thickness;
  final double? indent;

  Divider({this.thickness = 1, this.indent = 8})
      : super(schemaType: Divider.schemaName);

  factory Divider.fromJson(Map<String, dynamic> json) =>
      _$DividerFromJson(json);

  @override
  String get blockType => Divider.schemaName;
}

class DividerDescriptor extends ContentDescriptor {
  DividerDescriptor() : super(schemaType: Divider.schemaName, title: 'Divider');
}

class DividerContentBuilder extends ContentBuilder<Divider> {
  DividerContentBuilder()
      : super(
          content: TypeDescriptor(
              schemaType: Divider.schemaName,
              title: 'Divider',
              fromJson: Divider.fromJson),
          defaultLayout: DefaultDividerLayout(),
          defaultLayoutDescriptor: DefaultDividerLayout.typeDescriptor,
        );
}

final class DefaultDividerLayout extends LayoutConfiguration<Divider> {
  static const schemaName = '${Divider.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Divider Layout',
    fromJson: DefaultDividerLayout.fromJson,
  );

  DefaultDividerLayout()
      : super(schemaType: '${Divider.schemaName}.layout.default');

  factory DefaultDividerLayout.fromJson(Map<String, dynamic> json) =>
      DefaultDividerLayout();

  @override
  Widget build(BuildContext context, Divider content) {
    final child = f.Divider(
      thickness: content.thickness,
    );

    return content.indent != null && content.indent! > 0
        ? Padding(
            padding: EdgeInsets.all(content.indent!),
            child: child,
          )
        : child;
  }
}
