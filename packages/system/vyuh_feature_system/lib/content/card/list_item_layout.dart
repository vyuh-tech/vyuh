import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as sys;

part 'list_item_layout.g.dart';

@JsonSerializable()
class ListItemCardLayout extends LayoutConfiguration<sys.Card> {
  static const schemaName = '${sys.Card.schemaName}.layout.listItem';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'List Item Card Layout',
    fromJson: ListItemCardLayout.fromJson,
  );

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (content.image != null || content.imageUrl != null)
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8)),
                  height: 64,
                  width: 92,
                  child: sys.ContentImage(
                    url: content.imageUrl?.toString(),
                    ref: content.image,
                    fit: BoxFit.contain,
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (content.title != null)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            content.title!,
                            style: theme.textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                      ),
                    if (content.description != null)
                      Flexible(
                        child: Text(
                          content.description!,
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                  ],
                ),
              ),
              if (content.action != null)
                const Icon(Icons.chevron_right_rounded)
            ],
          ),
        ),
      ),
    );
  }
}
