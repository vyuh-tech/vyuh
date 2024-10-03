// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accordion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Accordion _$AccordionFromJson(Map<String, dynamic> json) => Accordion(
      title: json['title'] as String?,
      description: json['description'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => AccordionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      layout: typeFromFirstOfListJson(json['layout']),
    );

AccordionItem _$AccordionItemFromJson(Map<String, dynamic> json) =>
    AccordionItem(
      title: json['title'] as String? ?? '',
      iconIdentifier: json['iconIdentifier'] as String?,
      content: typeFromFirstOfListJson(json['content']),
    );
