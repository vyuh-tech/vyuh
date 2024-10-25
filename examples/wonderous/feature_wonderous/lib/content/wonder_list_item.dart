import 'package:feature_wonderous/api/wonder.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart' as vc;
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'wonder_list_item.g.dart';

@JsonSerializable()
final class WonderMiniInfo implements DocumentItem {
  @override
  String get schemaType => Wonder.schemaName;

  static const schemaName = '${Wonder.schemaName}.mini';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: WonderMiniInfo.fromJson,
    title: 'Wonder Mini Info',
  );

  final String identifier;
  final String title;
  final String subtitle;
  final ImageReference icon;

  final ImageReference image;

  @JsonKey(name: 'hexColor', fromJson: Wonder.colorFromJson)
  final Color color;

  Color? _textColor;

  Color get textColor {
    _textColor ??= Wonder.computeTextColor(color);

    return _textColor!;
  }

  WonderMiniInfo({
    required this.identifier,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.image,
    required this.color,
  });

  factory WonderMiniInfo.fromJson(Map<String, dynamic> json) =>
      _$WonderMiniInfoFromJson(json);
}

@JsonSerializable()
final class WonderListItemConfiguration
    extends DocumentItemConfiguration<WonderMiniInfo> {
  static const schemaName = '${Wonder.schemaName}.listItem';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Wonder List Item',
    fromJson: WonderListItemConfiguration.fromJson,
  );

  WonderListItemConfiguration({
    super.title,
  }) : super(schemaType: schemaName);

  factory WonderListItemConfiguration.fromJson(Map<String, dynamic> json) =>
      _$WonderListItemConfigurationFromJson(json);

  @override
  Widget build(BuildContext context, WonderMiniInfo document) =>
      _WonderItem(document: document);
}

class _WonderItem extends StatelessWidget {
  const _WonderItem({
    required this.document,
  });

  final WonderMiniInfo document;

  @override
  Widget build(BuildContext context) {
    return vyuh.content.buildContent(
      context,
      vf.Card(
        title: document.title,
        description: document.subtitle,
        image: document.icon,
        action: vc.Action(
          configurations: [
            NavigationAction(
              url: '/wonderous/wonder/${document.identifier}/details',
            ),
          ],
        ),
      ),
    );
  }
}
