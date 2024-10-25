import 'package:feature_wonderous/api/wonder.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'query_configurations.g.dart';

@JsonSerializable()
final class WonderListQueryConfiguration extends QueryConfiguration {
  WonderListQueryConfiguration() : super(schemaType: schemaName);

  static const schemaName = '${Wonder.schemaName}.query.list';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: WonderListQueryConfiguration.fromJson,
    title: 'Wonder List Query',
  );

  factory WonderListQueryConfiguration.fromJson(Map<String, dynamic> json) =>
      _$WonderListQueryConfigurationFromJson(json);

  @override
  String? buildQuery(BuildContext context) {
    return '''
*[ _type == "wonderous.wonder" ]{
  "_type": _type + ".mini", 
  identifier, image, icon, title, subtitle, hexColor
} | order(title asc)
''';
  }
}

@JsonSerializable()
final class WonderQueryConfiguration extends QueryConfiguration {
  static const schemaName = '${Wonder.schemaName}.query';
  WonderQueryConfiguration() : super(schemaType: schemaName);

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: WonderQueryConfiguration.fromJson,
    title: 'Wonder Query',
  );

  @override
  String? buildQuery(BuildContext context) {
    final wonderId = GoRouterState.of(context).pathParameters['wonder'];
    if (wonderId == null) {
      return null;
    }

    return '*[ _type == "wonderous.wonder" && identifier == "$wonderId" ][0]';
  }

  factory WonderQueryConfiguration.fromJson(Map<String, dynamic> json) =>
      _$WonderQueryConfigurationFromJson(json);
}
