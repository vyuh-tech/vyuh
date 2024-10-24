import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'wonder.g.dart';

@JsonSerializable()
final class Wonder implements DocumentItem {
  static const schemaName = 'wonderous.wonder';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Wonder',
    fromJson: Wonder.fromJson,
  );

  @override
  String get schemaType => schemaName;

  @JsonKey(name: 'hexColor', fromJson: colorFromJson)
  final Color color;

  Color? _textColor;

  Color get textColor {
    _textColor ??= computeTextColor(color);

    return _textColor!;
  }

  static Color computeTextColor(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  final String identifier;
  final int startYear;
  final int endYear;
  final String title;

  final String subtitle;
  final Location location;

  final Video video;
  final String unsplashCollectionId;
  final ImageReference icon;
  final ImageReference image;

  final ImageReference backdropImage;
  final Quote primaryQuote;

  final Quote secondaryQuote;
  final PortableTextContent history;
  final PortableTextContent construction;
  final PortableTextContent locationInfo;

  final List<Event> events;

  Wonder({
    required this.color,
    required this.title,
    required this.identifier,
    required this.subtitle,
    required this.location,
    required this.video,
    required this.startYear,
    required this.endYear,
    required this.unsplashCollectionId,
    required this.icon,
    required this.image,
    required this.backdropImage,
    required this.primaryQuote,
    required this.secondaryQuote,
    required this.history,
    required this.construction,
    required this.locationInfo,
    required this.events,
  });

  factory Wonder.fromJson(Map<String, dynamic> json) => _$WonderFromJson(json);

  static colorFromJson(String value) {
    final hex = int.tryParse(value, radix: 16) ?? 0;
    return Color(hex);
  }
}

@JsonSerializable()
final class Location {
  final String place;
  final double latitude;
  final double longitude;
  final String caption;

  Location({
    required this.place,
    required this.latitude,
    required this.longitude,
    required this.caption,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

@JsonSerializable()
class Video {
  final String videoId;
  final String caption;

  Video({
    required this.videoId,
    required this.caption,
  });

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
}

@JsonSerializable()
final class Quote {
  final String text;
  final String? author;

  Quote({
    required this.text,
    this.author,
  });
  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
}

@JsonSerializable()
class Event {
  final int year;
  final String title;

  Event({
    required this.year,
    required this.title,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
