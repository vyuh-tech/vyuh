import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

import '../layouts/venue_layout.dart';
import 'room.dart';

part 'venue.g.dart';

enum VenueAmenity {
  @JsonValue('free-wifi')
  freeWifi,
  @JsonValue('paid-wifi')
  paidWifi,
  @JsonValue('free-parking')
  freeParking,
  @JsonValue('paid-parking')
  paidParking,
  @JsonValue('food-court')
  foodCourt,
  cafeteria,
  restaurant,
  @JsonValue('coffee-shop')
  coffeeShop,
  @JsonValue('business-center')
  businessCenter,
  @JsonValue('fitness-center')
  fitnessCenter,
  @JsonValue('swimming-pool')
  swimmingPool,
  spa,
  atm,
  @JsonValue('currency-exchange')
  currencyExchange,
  @JsonValue('gift-shop')
  giftShop,
  @JsonValue('laundry-service')
  laundryService,
  concierge,
  @JsonValue('valet-parking')
  valetParking,
  @JsonValue('luggage-storage')
  luggageStorage,
  @JsonValue('room-service')
  roomService,
  @JsonValue('first-aid')
  firstAid,
  security,
  @JsonValue('coat-check')
  coatCheck,
  @JsonValue('prayer-room')
  prayerRoom,
  lounge;

  String get displayName {
    switch (this) {
      case VenueAmenity.freeWifi:
        return 'Free Wi-Fi';
      case VenueAmenity.paidWifi:
        return 'Paid Wi-Fi';
      case VenueAmenity.freeParking:
        return 'Free Parking';
      case VenueAmenity.paidParking:
        return 'Paid Parking';
      case VenueAmenity.foodCourt:
        return 'Food Court';
      case VenueAmenity.cafeteria:
        return 'Cafeteria';
      case VenueAmenity.restaurant:
        return 'Restaurant';
      case VenueAmenity.coffeeShop:
        return 'Coffee Shop';
      case VenueAmenity.businessCenter:
        return 'Business Center';
      case VenueAmenity.fitnessCenter:
        return 'Fitness Center';
      case VenueAmenity.swimmingPool:
        return 'Swimming Pool';
      case VenueAmenity.spa:
        return 'Spa';
      case VenueAmenity.atm:
        return 'ATM';
      case VenueAmenity.currencyExchange:
        return 'Currency Exchange';
      case VenueAmenity.giftShop:
        return 'Gift Shop';
      case VenueAmenity.laundryService:
        return 'Laundry Service';
      case VenueAmenity.concierge:
        return 'Concierge';
      case VenueAmenity.valetParking:
        return 'Valet Parking';
      case VenueAmenity.luggageStorage:
        return 'Luggage Storage';
      case VenueAmenity.roomService:
        return 'Room Service';
      case VenueAmenity.firstAid:
        return 'First Aid';
      case VenueAmenity.security:
        return 'Security';
      case VenueAmenity.coatCheck:
        return 'Coat Check';
      case VenueAmenity.prayerRoom:
        return 'Prayer Room';
      case VenueAmenity.lounge:
        return 'Lounge';
    }
  }
}

@JsonSerializable()
class Venue extends ContentItem {
  static const schemaName = 'conf.venue';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: Venue.fromJson,
    title: 'Venue',
  );

  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayout: VenueLayout(),
    defaultLayoutDescriptor: VenueLayout.typeDescriptor,
  );

  @JsonKey(name: '_id')
  final String id;

  final String title;
  final String slug;
  final PortableTextContent? description;
  final VenueAddress? address;
  final VenueCoordinates? coordinates;
  final String? website;
  final String? phone;
  final String? email;
  final List<Room>? rooms;
  final List<VenueAmenity>? amenities;
  final ImageReference? image;

  Venue({
    required this.id,
    this.title = 'Conference Center',
    required this.slug,
    this.description,
    this.address,
    this.coordinates,
    this.website,
    this.phone,
    this.email,
    this.rooms,
    this.amenities,
    this.image,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
}

@JsonSerializable()
class VenueAddress {
  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  VenueAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });

  factory VenueAddress.fromJson(Map<String, dynamic> json) =>
      _$VenueAddressFromJson(json);

  String get formatted => '$street, $city, $state $postalCode, $country';
}

@JsonSerializable()
class VenueCoordinates {
  final double latitude;
  final double longitude;

  VenueCoordinates({
    required this.latitude,
    required this.longitude,
  });

  factory VenueCoordinates.fromJson(Map<String, dynamic> json) =>
      _$VenueCoordinatesFromJson(json);
}
