import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';

final class LinearGradient extends flutter.ThemeExtension<LinearGradient> {
  final flutter.LinearGradient primaryGradient;

  final flutter.LinearGradient inversePrimaryGradient;

  final flutter.LinearGradient tertiaryGradient;

  final flutter.LinearGradient secondaryGradient;

  final flutter.LinearGradient inverseSecondaryGradient;

  const LinearGradient({
    this.primaryGradient = const flutter.LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: [0.0, 0.4],
      colors: [
        Color(0xffffffff),
        Color(0x03ffffff),
      ],
    ),
    this.inversePrimaryGradient = const flutter.LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0, 0.8],
      colors: [
        Color(0xfffcf8f8),
        Color(0x00fcf8f8),
      ],
    ),
    this.tertiaryGradient = const flutter.LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.center,
      stops: [0, 0.5],
      colors: [
        Color(0x99fcf8f8),
        Color(0x00fcf8f8),
      ],
    ),
    this.secondaryGradient = const flutter.LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [
        0.0,
        0.8,
      ],
      colors: [
        Color(0x121c1b1b),
        Color(0x001c1b1b),
      ],
    ),
    this.inverseSecondaryGradient = const flutter.LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.center,
      stops: [0.0, 0.8],
      colors: [
        Color(0xff2f2e2e),
        Color(0x66000000),
      ],
    ),
  });

  @override
  flutter.ThemeExtension<LinearGradient> copyWith() {
    return LinearGradient(
      primaryGradient: primaryGradient,
      inversePrimaryGradient: inversePrimaryGradient,
      tertiaryGradient: tertiaryGradient,
      secondaryGradient: secondaryGradient,
      inverseSecondaryGradient: inverseSecondaryGradient,
    );
  }

  @override
  flutter.ThemeExtension<LinearGradient> lerp(
    covariant flutter.ThemeExtension<LinearGradient>? other,
    double t,
  ) {
    if (other == null) return copyWith();
    return this;
  }
}
