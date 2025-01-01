import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

import '../layouts/venue_layout.dart';
import 'room.dart';

part 'venue.g.dart';

enum VenueAmenity {
  parking,
  restaurant,
  cafe,
  business,
  firstaid,
  security,
  coatcheck,
  prayer,
  lounge;

  String get displayName {
    switch (this) {
      case VenueAmenity.parking:
        return 'Free Parking';
      case VenueAmenity.restaurant:
        return 'Restaurant';
      case VenueAmenity.cafe:
        return 'Cafe';
      case VenueAmenity.business:
        return 'Business Center';
      case VenueAmenity.firstaid:
        return 'First Aid';
      case VenueAmenity.security:
        return 'Security';
      case VenueAmenity.coatcheck:
        return 'Coat Check';
      case VenueAmenity.prayer:
        return 'Prayer Room';
      case VenueAmenity.lounge:
        return 'Lounge';
    }
  }
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

  String get formatted =>
      '$street, $city, $state $postalCode, $country';
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

  final String name;
  final String? description;
  final VenueAddress address;
  final VenueCoordinates coordinates;
  final String? website;
  final String? phone;
  final String? email;
  final List<Room>? rooms;
  final List<VenueAmenity>? amenities;
  final ImageReference? image;

  Venue({
    required this.id,
    this.name = 'Conference Center',
    this.description,
    required this.address,
    required this.coordinates,
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
