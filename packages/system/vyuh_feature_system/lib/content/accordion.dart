import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'accordion.g.dart';

@JsonSerializable()
final class Accordion extends ContentItem {
  static const schemaName = 'vyuh.accordion';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Accordion',
    fromJson: Accordion.fromJson,
  );
  static final contentBuilder = ContentBuilder(
    content: Accordion.typeDescriptor,
    defaultLayout: DefaultAccordionLayout(),
    defaultLayoutDescriptor: DefaultAccordionLayout.typeDescriptor,
  );

  final String? title;
  final String? description;

  @JsonKey(defaultValue: [])
  final List<AccordionItem> items;

  Accordion({
    this.title,
    this.description,
    required this.items,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Accordion.fromJson(Map<String, dynamic> json) =>
      _$AccordionFromJson(json);
}

@JsonSerializable()
final class AccordionItem {
  @JsonKey(defaultValue: '')
  final String title;

  final String? iconIdentifier;

  @JsonKey(fromJson: typeFromFirstOfListJson<ContentItem>)
  final ContentItem? content;

  AccordionItem({
    required this.title,
    this.iconIdentifier,
    required this.content,
  });

  factory AccordionItem.fromJson(Map<String, dynamic> json) =>
      _$AccordionItemFromJson(json);
}

class AccordionDescriptor extends ContentDescriptor {
  AccordionDescriptor({super.layouts})
      : super(schemaType: Accordion.schemaName, title: 'Accordion');
}

final class DefaultAccordionLayout extends LayoutConfiguration<Accordion> {
  static const schemaName = '${Accordion.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Accordion Layout',
    fromJson: DefaultAccordionLayout.fromJson,
  );

  DefaultAccordionLayout() : super(schemaType: schemaName);

  factory DefaultAccordionLayout.fromJson(Map<String, dynamic> json) =>
      DefaultAccordionLayout();

  @override
  Widget build(BuildContext context, Accordion content) {
    return DefaultAccordionView(content: content);
  }
}

class DefaultAccordionView extends StatefulWidget {
  final Accordion content;

  const DefaultAccordionView({super.key, required this.content});

  @override
  State<DefaultAccordionView> createState() => _DefaultAccordionViewState();
}

class _DefaultAccordionViewState extends State<DefaultAccordionView> {
  final List<bool> _expansions = [];

  @override
  void initState() {
    super.initState();

    _expansions.addAll(
        List<bool>.generate(widget.content.items.length, (index) => false));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.content.title != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.content.title!,
                  style:
                      theme.textTheme.titleMedium?.apply(fontWeightDelta: 2)),
            ),
          if (widget.content.description != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.content.description!,
                style: theme.textTheme.bodyMedium
                    ?.apply(color: theme.colorScheme.secondary),
              ),
            ),
          ExpansionPanelList(
            expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 8),
            expansionCallback: (index, isExpanded) {
              setState(() {
                _expansions[index] = isExpanded;
              });
            },
            children: widget.content.items
                .mapIndexed((index, item) => ExpansionPanel(
                    canTapOnHeader: true,
                    isExpanded: _expansions[index],
                    headerBuilder: (_, isExpanded) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.apply(fontWeightDelta: isExpanded ? 3 : 0)),
                        ),
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: vyuh.content
                          .buildContent(context, item.content ?? Empty()),
                    )))
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}
