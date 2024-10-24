import 'dart:ui';

import 'package:flutter/material.dart' as flutter;

class BorderWidth extends flutter.ThemeExtension<BorderWidth> {
  final double none;
  final double small;
  final double medium;
  final double large;

  const BorderWidth({
    this.none = 0.0,
    this.small = 1.0,
    this.medium = 2.0,
    this.large = 4.0,
  });

  @override
  flutter.ThemeExtension<BorderWidth> copyWith({
    final double? none,
    final double? small,
    final double? medium,
    final double? large,
  }) =>
      BorderWidth(
        none: none ?? this.none,
        small: small ?? this.small,
        medium: medium ?? this.medium,
        large: large ?? this.large,
      );

  @override
  flutter.ThemeExtension<BorderWidth> lerp(
    final flutter.ThemeExtension<BorderWidth>? other,
    final double t,
  ) {
    if (other is! BorderWidth) {
      return this;
    }
    return BorderWidth(
      none: lerpDouble(
            none,
            other.none,
            t,
          ) ??
          none,
      small: lerpDouble(
            small,
            other.small,
            t,
          ) ??
          small,
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
    );
  }
}
