import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

@JsonSerializable()
final class TMDBImageSet {
  final List<TMDBImage> backdrops;
  final List<TMDBImage> posters;

  TMDBImageSet({required this.backdrops, required this.posters});

  factory TMDBImageSet.fromJson(Map<String, dynamic> json) =>
      _$TMDBImageSetFromJson(json);
}

@JsonSerializable()
final class TMDBImage {
  @JsonKey(name: 'file_path')
  final String? path;

  final int? width;
  final int? height;
  final double? aspectRatio;

  late final image = posterImageFromPath(path);
  late final originalImage = posterImageOriginalFromPath(path);

  TMDBImage({
    required this.path,
    this.width,
    this.height,
    this.aspectRatio,
  });

  factory TMDBImage.fromJson(Map<String, dynamic> json) =>
      _$TMDBImageFromJson(json);
}

enum PosterImageSize {
  w92,
  w154,
  w185,
  w342,
  w500,
  w780,
  original,
}

enum BackdropImageSize {
  w300,
  w780,
  w1280,
  original,
}

enum LogoImageSize {
  w45,
  w92,
  w154,
  w185,
  w300,
  w500,
  original,
}

enum ProfileImageSize {
  w45,
  w185,
  h632,
  original,
}

String? Function(String? value) imageFromPath(String imageSizePrefix) =>
    (String? value) {
      if (value == null) {
        return null;
      }

      return 'https://image.tmdb.org/t/p/$imageSizePrefix$value';
    };

String? profileImageFromPath(String? value) {
  return imageFromPath(ProfileImageSize.w185.name)(value);
}

String? largeProfileImageFromPath(String? value) {
  return imageFromPath(ProfileImageSize.h632.name)(value);
}

String? backdropImageFromPath(String? value) {
  return imageFromPath(BackdropImageSize.w300.name)(value);
}

String? posterImageFromPath(String? value) {
  return imageFromPath(PosterImageSize.w342.name)(value);
}

String? posterImageOriginalFromPath(String? value) {
  return imageFromPath(PosterImageSize.original.name)(value);
}

String? logoImageFromPath(String? value) {
  return imageFromPath(LogoImageSize.w154.name)(value);
}
