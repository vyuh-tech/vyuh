import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_path/json_path.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/content/card/list_item_layout.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'simple_api_handler.g.dart';

@JsonSerializable()
final class DisplayFieldMap {
  final JSONPath? title;
  final JSONPath? description;
  final JSONPath? imageUrl;

  DisplayFieldMap({this.title, this.description, this.imageUrl});

  factory DisplayFieldMap.fromJson(Map<String, dynamic> json) =>
      _$DisplayFieldMapFromJson(json);
}

extension type const JSONPath(String path) {
  factory JSONPath.fromJson(dynamic value) => JSONPath(value);
}

@JsonSerializable()
final class SimpleAPIHandler extends APIHandler<List<vf.Card>> {
  static const schemaName = 'vyuh.apiContent.handler.simple';

  final String? title;
  final String url;
  final Map<String, String>? headers;
  final List<(String name, String value)>? requestBody;

  final JSONPath rootField;
  final DisplayFieldMap? fieldMap;

  static final typeDescriptor = TypeDescriptor(
    schemaType: SimpleAPIHandler.schemaName,
    fromJson: SimpleAPIHandler.fromJson,
    title: 'Simple API Handler',
  );

  SimpleAPIHandler({
    this.title,
    this.url = '',
    this.headers,
    this.requestBody,
    this.rootField = const JSONPath(r'$'),
    this.fieldMap,
  }) : super(schemaType: schemaName);

  factory SimpleAPIHandler.fromJson(Map<String, dynamic> json) =>
      _$SimpleAPIHandlerFromJson(json);

  @override
  Future<List<vf.Card>?> invoke(BuildContext context) async {
    final response = await vyuh.network.get(Uri.parse(url));
    final json = jsonDecode(response.body);

    final rootItem = JsonPath(rootField.path).read(json);
    if (rootItem.singleOrNull == null) return null;

    final root = rootItem.single.value;

    return switch (root) {
      List() => root.map((e) => _createCard(e)).toList(),
      Map() => [_createCard(root.values.first)],
      _ => null
    };
  }

  vf.Card _createCard(Map<String, dynamic> json) {
    final fields = {
      'title': fieldMap?.title,
      'description': fieldMap?.description,
      'imageUrl': fieldMap?.imageUrl,
    }.entries.where((x) => x.value != null).map((e) {
      final value =
          JsonPath(e.value!.path).read(json).singleOrNull?.value as String?;
      return MapEntry(e.key, value);
    }).fold(<String, String?>{}, (previousValue, element) {
      previousValue[element.key] = element.value;
      return previousValue;
    });

    return vf.Card(
      title: fields['title'],
      description: fields['description'],
      imageUrl:
          fields['imageUrl'] != null ? Uri.parse(fields['imageUrl']!) : null,
      layout: ListItemCardLayout(title: 'List Item'),
    );
  }

  @override
  Widget buildData(BuildContext context, List<vf.Card>? data) {
    return data == null ? empty : _buildCardList(data);
  }

  _buildCardList(List<vf.Card> data) {
    return LimitedBox(
      maxHeight: 200,
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) =>
              vyuh.content.buildContent(context, data[index])),
    );
  }
}
