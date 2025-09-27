import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'conditional_layout.g.dart';

@JsonSerializable()
final class LayoutCaseItem {
  final String value;

  @JsonKey(fromJson: typeFromFirstOfListJson<LayoutConfiguration>)
  final LayoutConfiguration? item;

  LayoutCaseItem({this.value = '', required this.item});

  factory LayoutCaseItem.fromJson(Map<String, dynamic> json) =>
      _$LayoutCaseItemFromJson(json);
}

@JsonSerializable(createFactory: false)
abstract class ConditionalLayout<T extends ContentItem>
    extends LayoutConfiguration<T> {
  final List<LayoutCaseItem> cases;
  final String defaultCase;
  final Condition condition;

  ConditionalLayout({
    required super.schemaType,
    required this.cases,
    required this.defaultCase,
    required this.condition,
  });

  factory ConditionalLayout.fromJson(Map<String, dynamic> json) {
    final type = VyuhBinding.instance.content.provider.schemaType(json);

    final layout =
        VyuhBinding.instance.content.fromJson<LayoutConfiguration>(json) ??
            UnknownConditionalLayout(missingSchemaType: type);

    return layout as ConditionalLayout<T>;
  }

  @override
  Widget build(BuildContext context, T content) {
    return FutureBuilder(
        future: condition.execute(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active || ConnectionState.done:
              if (snapshot.hasError) {
                return VyuhBinding.instance.widgetBuilder.errorView(
                  context,
                  error: snapshot.error,
                  title:
                      'Failed to execute condition: ${condition.configuration?.schemaType}.',
                );
              }

              final value = snapshot.data ?? defaultCase;

              final caseItem =
                  cases.firstWhereOrNull((element) => element.value == value);

              return caseItem?.item?.build(context, content) ??
                  VyuhBinding.instance.widgetBuilder.errorView(context,
                      title:
                          'No LayoutConfiguration for content with schemaType: ${content.schemaType}.',
                      subtitle: 'Condition evaluated to: $value.');
            default:
              return VyuhBinding.instance.widgetBuilder.contentLoader(context);
          }
        });
  }
}

final class UnknownConditionalLayout<T extends ContentItem>
    extends ConditionalLayout<T> {
  final String missingSchemaType;

  UnknownConditionalLayout({required this.missingSchemaType})
      : super(
          schemaType: 'vyuh.unknown.layout.conditional',
          cases: [],
          defaultCase: 'default',
          condition: Condition(),
        );

  @override
  Widget build(BuildContext context, T content) {
    final failure = LayoutFailure(
      schemaType: missingSchemaType,
      contentSchemaType: content.schemaType,
      description: 'Missing ConditionalLayout with schemaType: $missingSchemaType',
      suggestions: [
        'Register a ConditionalLayout for $missingSchemaType',
        'Check if the layout type is properly exported',
      ],
    );

    return VyuhBinding.instance.widgetBuilder.unknown(context, failure);
  }
}
