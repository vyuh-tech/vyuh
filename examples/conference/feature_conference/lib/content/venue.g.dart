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
      title: json['title'] as String? ?? 'Conference Center',
      slug: json['slug'] as String,
      description: json['description'] as String?,
      address: json['address'] == null
          ? null
          : VenueAddress.fromJson(json['address'] as Map<String, dynamic>),
      coordinates: json['coordinates'] == null
          ? null
          : VenueCoordinates.fromJson(
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
  VenueAmenity.freeWifi: 'free-wifi',
  VenueAmenity.paidWifi: 'paid-wifi',
  VenueAmenity.freeParking: 'free-parking',
  VenueAmenity.paidParking: 'paid-parking',
  VenueAmenity.foodCourt: 'food-court',
  VenueAmenity.cafeteria: 'cafeteria',
  VenueAmenity.restaurant: 'restaurant',
  VenueAmenity.coffeeShop: 'coffee-shop',
  VenueAmenity.businessCenter: 'business-center',
  VenueAmenity.fitnessCenter: 'fitness-center',
  VenueAmenity.swimmingPool: 'swimming-pool',
  VenueAmenity.spa: 'spa',
  VenueAmenity.atm: 'atm',
  VenueAmenity.currencyExchange: 'currency-exchange',
  VenueAmenity.giftShop: 'gift-shop',
  VenueAmenity.laundryService: 'laundry-service',
  VenueAmenity.concierge: 'concierge',
  VenueAmenity.valetParking: 'valet-parking',
  VenueAmenity.luggageStorage: 'luggage-storage',
  VenueAmenity.roomService: 'room-service',
  VenueAmenity.firstAid: 'first-aid',
  VenueAmenity.security: 'security',
  VenueAmenity.coatCheck: 'coat-check',
  VenueAmenity.prayerRoom: 'prayer-room',
  VenueAmenity.lounge: 'lounge',
};
