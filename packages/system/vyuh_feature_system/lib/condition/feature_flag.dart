import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'feature_flag.g.dart';

@JsonSerializable()
final class FeatureFlagCondition extends ConditionConfiguration {
  static const schemaName = 'vyuh.condition.featureFlag';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Feature Flag Condition',
    fromJson: FeatureFlagCondition.fromJson,
  );

  final String flagName;

  final FlagDataType dataType;

  FeatureFlagCondition(
      {this.flagName = '', this.dataType = FlagDataType.string})
      : super(schemaType: schemaName);

  factory FeatureFlagCondition.fromJson(Map<String, dynamic> json) =>
      _$FeatureFlagConditionFromJson(json);

  @override
  Future<String?> execute(BuildContext context) async {
    if (flagName.isEmpty) {
      return null;
    }

    switch (dataType) {
      case FlagDataType.string:
        return vyuh.featureFlag?.getString(flagName);
      case FlagDataType.number:
        final value = await vyuh.featureFlag?.getInt(flagName);
        return value.toString();
      case FlagDataType.boolean:
        final value = await vyuh.featureFlag?.getBool(flagName);
        return value.toString();
      case FlagDataType.json:
        final value = await vyuh.featureFlag?.getJson(flagName);
        return jsonEncode(value);
    }
  }
}

enum FlagDataType {
  string,
  number,
  boolean,
  json,
}
