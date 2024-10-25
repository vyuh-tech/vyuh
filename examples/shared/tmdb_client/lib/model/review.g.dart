// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      author: json['author'] as String,
      content: json['content'] as String,
      authorDetails:
          ReviewAuthor.fromJson(json['author_details'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

ReviewAuthor _$ReviewAuthorFromJson(Map<String, dynamic> json) => ReviewAuthor(
      name: json['name'] as String,
      avatarImage: profileImageFromPath(json['avatar_path'] as String?),
    );
