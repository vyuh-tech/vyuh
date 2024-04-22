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
    final type = vyuh.content.provider.schemaType(json);

    final layout = vyuh.content.fromJson<LayoutConfiguration>(json) ??
        UnknownConditionalLayout(missingSchemaType: type);

    return layout as ConditionalLayout<T>;
  }

  @override
  Widget build(BuildContext context, T content) {
    return FutureBuilder(
        future: condition.execute(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active || ConnectionState.done:
              if (snapshot.hasError) {
                return vyuh.widgetBuilder.errorView(
                  error: snapshot.error,
                  title:
                      'Failed to execute condition: ${condition.configuration?.schemaType}.',
                );
              }

              final value = snapshot.data ?? defaultCase;

              final caseItem =
                  cases.firstWhereOrNull((element) => element.value == value);
              return caseItem?.item?.build(context, content) ??
                  vyuh.widgetBuilder.errorView(
                      title:
                          'Missing LayoutConfiguration for content with schemaType: ${content.schemaType}');
            default:
              return vyuh.widgetBuilder.contentLoader();
          }
        });
  }
}

final class UnknownConditionalLayout<T extends ContentItem>
    extends ConditionalLayout<T> {
  final String missingSchemaType;

  UnknownConditionalLayout({required this.missingSchemaType})
      : super(
          schemaType: '${Unknown.schemaName}.layout.conditional',
          cases: [],
          defaultCase: 'default',
          condition: Condition(),
        );

  @override
  Widget build(BuildContext context, T content) {
    final unknown = Unknown(
        missingSchemaType: missingSchemaType,
        description:
            'This is due to a missing ConditionalLayout with schemaType: $missingSchemaType.');

    return vyuh.content.buildContent(context, unknown);
  }
}
