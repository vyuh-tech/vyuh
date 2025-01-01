// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueAddress _$VenueAddressFromJson(Map<String, dynamic> json) => VenueAddress(
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      postalCode: json['postalCode'] as String,
    );

VenueCoordinates _$VenueCoordinatesFromJson(Map<String, dynamic> json) =>
    VenueCoordinates(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Venue _$VenueFromJson(Map<String, dynamic> json) => Venue(
      id: json['_id'] as String,
      name: json['name'] as String? ?? 'Conference Center',
      description: json['description'] as String?,
      address: VenueAddress.fromJson(json['address'] as Map<String, dynamic>),
      coordinates: VenueCoordinates.fromJson(
          json['coordinates'] as Map<String, dynamic>),
      website: json['website'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      rooms: (json['rooms'] as List<dynamic>?)
          ?.map((e) => Room.fromJson(e as Map<String, dynamic>))
          .toList(),
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$VenueAmenityEnumMap, e))
          .toList(),
      image: json['image'] == null
          ? null
          : ImageReference.fromJson(json['image'] as Map<String, dynamic>),
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );

const _$VenueAmenityEnumMap = {
  VenueAmenity.parking: 'parking',
  VenueAmenity.restaurant: 'restaurant',
  VenueAmenity.cafe: 'cafe',
  VenueAmenity.business: 'business',
  VenueAmenity.firstaid: 'firstaid',
  VenueAmenity.security: 'security',
  VenueAmenity.coatcheck: 'coatcheck',
  VenueAmenity.prayer: 'prayer',
  VenueAmenity.lounge: 'lounge',
};
