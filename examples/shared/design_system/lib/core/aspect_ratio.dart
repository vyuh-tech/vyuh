import 'dart:ui';

import 'package:flutter/material.dart' as flutter;

class AspectRatio extends flutter.ThemeExtension<AspectRatio> {
  final double nineToSixteen;
  final double fourToFive;
  final double oneToOne;
  final double fourToThree;
  final double threeToTwo;
  final double sixteenToNine;
  final double twoToOne;
  final double fourToOne;

  const AspectRatio({
    this.nineToSixteen = 9 / 16,
    this.fourToFive = 4 / 5,
    this.oneToOne = 1 / 1,
    this.fourToThree = 4 / 3,
    this.threeToTwo = 3 / 2,
    this.sixteenToNine = 16 / 9,
    this.twoToOne = 2 / 1,
    this.fourToOne = 4 / 1,
  });

  @override
  flutter.ThemeExtension<AspectRatio> copyWith({
    final double? nineToSixteen,
    final double? fourToFive,
    final double? oneToOne,
    final double? fourToThree,
    final double? threeToTwo,
    final double? sixteenToNine,
    final double? twoToOne,
    final double? fourToOne,
  }) =>
      AspectRatio(
        nineToSixteen: nineToSixteen ?? this.nineToSixteen,
        fourToFive: fourToFive ?? this.fourToFive,
        oneToOne: oneToOne ?? this.oneToOne,
        fourToThree: fourToThree ?? this.fourToThree,
        threeToTwo: threeToTwo ?? this.threeToTwo,
        sixteenToNine: sixteenToNine ?? this.sixteenToNine,
        twoToOne: twoToOne ?? this.twoToOne,
        fourToOne: fourToOne ?? this.fourToOne,
      );

  @override
  flutter.ThemeExtension<AspectRatio> lerp(
    final flutter.ThemeExtension<AspectRatio>? other,
    final double t,
  ) {
    if (other is! AspectRatio) {
      return this;
    }
    return AspectRatio(
      nineToSixteen: lerpDouble(
            nineToSixteen,
            other.nineToSixteen,
            t,
          ) ??
          nineToSixteen,
      fourToFive: lerpDouble(
            fourToFive,
            other.fourToFive,
            t,
          ) ??
          fourToFive,
      oneToOne: lerpDouble(
            oneToOne,
            other.oneToOne,
            t,
          ) ??
          oneToOne,
      fourToThree: lerpDouble(
            fourToThree,
            other.fourToThree,
            t,
          ) ??
          fourToThree,
      threeToTwo: lerpDouble(
            threeToTwo,
            other.threeToTwo,
            t,
          ) ??
          threeToTwo,
      sixteenToNine: lerpDouble(
            sixteenToNine,
            other.sixteenToNine,
            t,
          ) ??
          sixteenToNine,
      twoToOne: lerpDouble(
            twoToOne,
            other.twoToOne,
            t,
          ) ??
          twoToOne,
      fourToOne: lerpDouble(
            fourToOne,
            other.fourToOne,
            t,
          ) ??
          fourToOne,
    );
  }
}
