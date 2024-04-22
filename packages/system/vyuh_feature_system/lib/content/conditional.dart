import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'conditional.g.dart';

@JsonSerializable()
class Conditional extends ContentItem {
  static const schemaName = 'vyuh.conditional';

  @JsonKey(defaultValue: [])
  final List<CaseItem>? cases;

  final String? defaultCase;
  final Condition? condition;

  Conditional({this.cases, this.condition, this.defaultCase})
      : super(schemaType: Conditional.schemaName);

  factory Conditional.fromJson(Map<String, dynamic> json) =>
      _$ConditionalFromJson(json);

  Future<ContentItem?> execute() async {
    final value = (await condition?.execute()) ?? defaultCase;

    final caseItem =
        cases?.firstWhereOrNull((element) => element.value == value);
    return caseItem?.item;
  }
}

@JsonSerializable()
final class CaseItem<T extends SchemaItem> {
  final String? value;

  @JsonKey(fromJson: typeFromFirstOfListJson<ContentItem>)
  final ContentItem? item;

  CaseItem({this.value, this.item});

  factory CaseItem.fromJson(Map<String, dynamic> json) =>
      _$CaseItemFromJson(json);
}

class ConditionalDescriptor extends ContentDescriptor {
  ConditionalDescriptor({super.layouts})
      : super(schemaType: Conditional.schemaName, title: 'Conditional');
}

final class ConditionalContentBuilder extends ContentBuilder<Conditional> {
  ConditionalContentBuilder()
      : super(
          content: TypeDescriptor(
              schemaType: Conditional.schemaName,
              title: 'Conditional',
              fromJson: Conditional.fromJson),
          defaultLayout: DefaultConditionalLayout(),
          defaultLayoutDescriptor: DefaultConditionalLayout.typeDescriptor,
        );
}

final class DefaultConditionalLayout extends LayoutConfiguration<Conditional> {
  static const schemaName = '${Conditional.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Conditional Layout',
    fromJson: DefaultConditionalLayout.fromJson,
  );

  DefaultConditionalLayout() : super(schemaType: schemaName);

  factory DefaultConditionalLayout.fromJson(Map<String, dynamic> json) =>
      DefaultConditionalLayout();

  @override
  Widget build(BuildContext context, Conditional content) =>
      _ConditionalBuilder(conditional: content);
}

class _ConditionalBuilder extends StatefulWidget {
  final Conditional conditional;

  const _ConditionalBuilder({required this.conditional});

  @override
  State<_ConditionalBuilder> createState() => _ConditionalBuilderState();
}

class _ConditionalBuilderState extends State<_ConditionalBuilder> {
  late final ObservableFuture<ContentItem?> _future;

  @override
  void initState() {
    super.initState();
    _future = ObservableFuture(Future.value(widget.conditional.execute()));
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      switch (_future.status) {
        case FutureStatus.pending:
          return vyuh.widgetBuilder.contentLoader();

        case FutureStatus.rejected || FutureStatus.fulfilled:
          final item = _future.value;
          return item == null
              ? Container()
              : vyuh.content.buildContent(context, item);
      }
    });
  }
}
