import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as sys;

part 'list_item_layout.g.dart';

@JsonSerializable()
class ListItemCardLayout extends LayoutConfiguration<sys.Card> {
  static const schemaName = '${sys.Card.schemaName}.layout.listItem';

  @JsonKey(defaultValue: '')
  final String title;

  ListItemCardLayout({required this.title}) : super(schemaType: schemaName);

  factory ListItemCardLayout.fromJson(Map<String, dynamic> json) =>
      _$ListItemCardLayoutFromJson(json);

  @override
  Widget build(BuildContext context, sys.Card content) {
    final theme = Theme.of(context);

    return sys.PressEffect(
      onTap: (context) => content.action?.execute(context),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  if (content.image?.asset?.ref != null)
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      height: 64,
                      width: 128,
                      child: sys.ContentImage(
                        ref: content.image?.asset?.ref,
                        fit: BoxFit.contain,
                      ),
                    ),
                  if (content.title != null)
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        content.title!,
                        style: theme.textTheme.bodyLarge,
                      ),
                    )),
                  const Icon(Icons.chevron_right_rounded)
                ],
              ),
              if (content.description != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    content.description!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
