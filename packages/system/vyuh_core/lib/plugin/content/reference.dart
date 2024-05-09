import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'reference.g.dart';

@JsonSerializable()
class ImageReference {
  final ObjectReference? asset;

  @JsonKey(name: '_sanityAsset')
  final String? sanityAsset;

  ImageReference({
    required this.asset,
    this.sanityAsset,
  });

  factory ImageReference.fromJson(final Map<String, dynamic> json) =>
      _$ImageReferenceFromJson(json);
}

@JsonSerializable()
class ObjectReference {
  @JsonKey(readValue: readValue)
  final String type;

  @JsonKey(readValue: readValue)
  final String ref;

  ObjectReference({required this.type, required this.ref});

  factory ObjectReference.fromJson(Map<String, dynamic> json) =>
      _$ObjectReferenceFromJson(json);
}
