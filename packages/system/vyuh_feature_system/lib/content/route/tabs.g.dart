// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TabsRouteLayout _$TabsRouteLayoutFromJson(Map<String, dynamic> json) =>
    TabsRouteLayout(
      routes: (json['routes'] as List<dynamic>)
          .map((e) => LinkedRoute.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

LinkedRoute _$LinkedRouteFromJson(Map<String, dynamic> json) => LinkedRoute(
      title: json['title'] as String?,
      identifier: json['identifier'] as String?,
      route: ObjectReference.fromJson(json['route'] as Map<String, dynamic>),
      description: json['description'] as String?,
    );
