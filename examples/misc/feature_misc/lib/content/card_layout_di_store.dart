import 'package:feature_misc/lifecycle_handlers/di_registration_lifecycle_handler.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/material.dart' as f;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'card_layout_di_store.g.dart';

@JsonSerializable()
class DIStoreCardLayout extends LayoutConfiguration<Card> {
  static const schemaName = 'misc.card.layout.diStore';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: DIStoreCardLayout.fromJson,
    title: 'DI Store Card Layout',
  );

  DIStoreCardLayout() : super(schemaType: schemaName);

  factory DIStoreCardLayout.fromJson(Map<String, dynamic> json) =>
      _$DIStoreCardLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Card content) {
    final title = context.di.get<TestStore>().title;

    final theme = Theme.of(context);

    return f.Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('The below text is read from a Route-Scoped DI Store',
                style: theme.textTheme.labelSmall),
            Text(title,
                style: theme.textTheme.titleMedium?.apply(
                  fontWeightDelta: 2,
                  color: theme.colorScheme.primary,
                )),
          ],
        ),
      ),
    );
  }
}
