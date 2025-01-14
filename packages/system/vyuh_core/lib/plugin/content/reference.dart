import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'reference.g.dart';

/// A reference to an image asset in the content management system.
/// 
/// This class represents an image reference that can be used in content models.
/// It supports both direct asset references and Sanity-specific image assets.
/// 
/// Example:
/// ```dart
/// final imageRef = ImageReference(
///   type: 'image',
///   asset: ObjectReference(type: 'reference', ref: 'image-abc123'),
/// );
/// ```
@JsonSerializable()
class ImageReference {
  @JsonKey(readValue: readValue)
  final String type;

  final ObjectReference? asset;

  @JsonKey(name: '_sanityAsset')
  final String? sanityAsset;

  ImageReference({
    required this.type,
    required this.asset,
    this.sanityAsset,
  });

  factory ImageReference.fromJson(final Map<String, dynamic> json) =>
      _$ImageReferenceFromJson(json);
}

/// A reference to a file asset in the content management system.
/// 
/// This class represents a file reference that can be used in content models.
/// It supports file assets like PDFs, documents, or other binary files.
/// 
/// Example:
/// ```dart
/// final fileRef = FileReference(
///   type: 'file',
///   asset: ObjectReference(type: 'reference', ref: 'file-abc123'),
/// );
/// ```
@JsonSerializable()
class FileReference {
  @JsonKey(readValue: readValue)
  final String type;

  final ObjectReference? asset;

  FileReference({
    required this.type,
    required this.asset,
  });

  factory FileReference.fromJson(final Map<String, dynamic> json) =>
      _$FileReferenceFromJson(json);
}

/// A reference to any content object in the content management system.
/// 
/// This class represents a generic reference to any content item. It is used
/// to establish relationships between content items, such as references to
/// images, files, or other content types.
/// 
/// The [type] field indicates the type of reference (e.g., 'reference', 'image').
/// The [ref] field contains the unique identifier of the referenced content.
/// 
/// Example:
/// ```dart
/// final ref = ObjectReference(
///   type: 'reference',
///   ref: 'content-abc123',
/// );
/// ```
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
