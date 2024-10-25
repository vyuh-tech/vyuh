// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wonder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wonder _$WonderFromJson(Map<String, dynamic> json) => Wonder(
      color: Wonder.colorFromJson(json['hexColor'] as String),
      title: json['title'] as String,
      identifier: json['identifier'] as String,
      subtitle: json['subtitle'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      video: Video.fromJson(json['video'] as Map<String, dynamic>),
      startYear: (json['startYear'] as num).toInt(),
      endYear: (json['endYear'] as num).toInt(),
      unsplashCollectionId: json['unsplashCollectionId'] as String,
      icon: ImageReference.fromJson(json['icon'] as Map<String, dynamic>),
      image: ImageReference.fromJson(json['image'] as Map<String, dynamic>),
      backdropImage: ImageReference.fromJson(
          json['backdropImage'] as Map<String, dynamic>),
      primaryQuote:
          Quote.fromJson(json['primaryQuote'] as Map<String, dynamic>),
      secondaryQuote:
          Quote.fromJson(json['secondaryQuote'] as Map<String, dynamic>),
      history:
          PortableTextContent.fromJson(json['history'] as Map<String, dynamic>),
      construction: PortableTextContent.fromJson(
          json['construction'] as Map<String, dynamic>),
      locationInfo: PortableTextContent.fromJson(
          json['locationInfo'] as Map<String, dynamic>),
      events: (json['events'] as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      place: json['place'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      caption: json['caption'] as String,
    );

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      videoId: json['videoId'] as String,
      caption: json['caption'] as String,
    );

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
      text: json['text'] as String,
      author: json['author'] as String?,
    );

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      year: (json['year'] as num).toInt(),
      title: json['title'] as String,
    );
