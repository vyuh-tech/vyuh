import 'dart:ui';

import 'package:flutter/material.dart' as flutter;

class BorderRadius extends flutter.ThemeExtension<BorderRadius> {
  final double none;
  final double xxSmall;
  final double xSmall;
  final double small;
  final double normal;
  final double medium;
  final double large;
  final double xLarge;
  double full(final double width) => 0.5 * width;

  const BorderRadius({
    this.none = 0.0,
    this.xxSmall = 2.0,
    this.xSmall = 4.0,
    this.small = 8.0,
    this.normal = 12.0,
    this.medium = 16.0,
    this.large = 20.0,
    this.xLarge = 24.0,
  });

  @override
  flutter.ThemeExtension<BorderRadius> copyWith({
    final double? none,
    final double? xxSmall,
    final double? xSmall,
    final double? small,
    final double? normal,
    final double? medium,
    final double? large,
    final double? xLarge,
  }) =>
      BorderRadius(
        none: none ?? this.none,
        xxSmall: xxSmall ?? this.xxSmall,
        xSmall: xSmall ?? this.xSmall,
        small: small ?? this.small,
        normal: normal ?? this.normal,
        medium: medium ?? this.medium,
        large: large ?? this.large,
        xLarge: xLarge ?? this.xLarge,
      );

  @override
  flutter.ThemeExtension<BorderRadius> lerp(
    final flutter.ThemeExtension<BorderRadius>? other,
    final double t,
  ) {
    if (other is! BorderRadius) {
      return this;
    }
    return BorderRadius(
      none: lerpDouble(
            none,
            other.none,
            t,
          ) ??
          none,
      xxSmall: lerpDouble(
            xxSmall,
            other.xxSmall,
            t,
          ) ??
          xxSmall,
      xSmall: lerpDouble(
            xSmall,
            other.xSmall,
            t,
          ) ??
          xSmall,
      small: lerpDouble(
            small,
            other.small,
            t,
          ) ??
          small,
      normal: lerpDouble(
            normal,
            other.normal,
            t,
          ) ??
          normal,
      medium: lerpDouble(
            medium,
            other.medium,
            t,
          ) ??
          medium,
      large: lerpDouble(
            large,
            other.large,
            t,
          ) ??
          large,
      xLarge: lerpDouble(
            xLarge,
            other.xLarge,
            t,
          ) ??
          xLarge,
    );
  }
}
