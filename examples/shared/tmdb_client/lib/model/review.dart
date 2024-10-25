import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_client/model/image.dart';

part 'review.g.dart';

@JsonSerializable()
final class Review {
  final String author;
  final String content;

  @JsonKey(name: 'author_details')
  final ReviewAuthor authorDetails;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Review({
    required this.author,
    required this.content,
    required this.authorDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}

@JsonSerializable()
final class ReviewAuthor {
  final String name;
  @JsonKey(name: 'avatar_path', fromJson: profileImageFromPath)
  final String? avatarImage;

  ReviewAuthor({required this.name, required this.avatarImage});

  factory ReviewAuthor.fromJson(Map<String, dynamic> json) =>
      _$ReviewAuthorFromJson(json);
}
