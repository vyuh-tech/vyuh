import 'dart:ui';

import 'package:flutter/material.dart' as flutter;

class Sizing extends flutter.ThemeExtension<Sizing> {
  final double s2;
  final double s3;
  final double s4;
  final double s5;
  final double s6;
  final double s7;
  final double s8;
  final double s9;
  final double s10;
  final double s12;
  final double s13;
  final double s14;
  final double s15;
  final double s16;
  final double s17;
  final double s18;
  final double s20;
  final double s22;
  final double s28;
  final double s31;
  final double s32;
  final double s36;
  final double s50;
  final double s64;
  final double s70;
  final double s74;
  final double quarter;
  final double half;
  final double base;
  double width20(final double width) => 0.2 * width;
  double width23(final double width) => 0.23 * width;
  double width31(final double width) => 0.31 * width;
  double width36(final double width) => 0.36 * width;
  double width43(final double width) => 0.43 * width;
  double width49(final double width) => 0.49 * width;
  double width53(final double width) => 0.53 * width;
  double width62(final double width) => 0.62 * width;
  double width64(final double width) => 0.64 * width;
  double width67(final double width) => 0.67 * width;
  double width80(final double width) => 0.8 * width;
  double width88(final double width) => 0.88 * width;
  double width91(final double width) => 0.91 * width;
  double width95(final double width) => 0.95 * width;
  double widthFull(final double width) => 1.0 * width;

  const Sizing({
    this.s2 = 8.0,
    this.s3 = 12.0,
    this.s4 = 16.0,
    this.s5 = 20.0,
    this.s6 = 24.0,
    this.s7 = 28.0,
    this.s8 = 32.0,
    this.s9 = 36.0,
    this.s10 = 40.0,
    this.s12 = 48.0,
    this.s13 = 52.0,
    this.s14 = 56.0,
    this.s15 = 60.0,
    this.s16 = 64.0,
    this.s17 = 68.0,
    this.s18 = 72.0,
    this.s20 = 80.0,
    this.s22 = 88.0,
    this.s28 = 112.0,
    this.s31 = 124.0,
    this.s32 = 128.0,
    this.s36 = 144.0,
    this.s50 = 200.0,
    this.s64 = 256.0,
    this.s70 = 300.0,
    this.s74 = 350.0,
    this.quarter = 1.0,
    this.half = 2.0,
    this.base = 4.0,
  });

  @override
  flutter.ThemeExtension<Sizing> copyWith({
    final double? s2,
    final double? s3,
    final double? s4,
    final double? s5,
    final double? s6,
    final double? s7,
    final double? s8,
    final double? s9,
    final double? s10,
    final double? s12,
    final double? s13,
    final double? s14,
    final double? s15,
    final double? s16,
    final double? s17,
    final double? s18,
    final double? s20,
    final double? s22,
    final double? s28,
    final double? s31,
    final double? s32,
    final double? s36,
    final double? s50,
    final double? s64,
    final double? s70,
    final double? s74,
    final double? quarter,
    final double? half,
    final double? base,
  }) =>
      Sizing(
        s2: s2 ?? this.s2,
        s3: s3 ?? this.s3,
        s4: s4 ?? this.s4,
        s5: s5 ?? this.s5,
        s6: s6 ?? this.s6,
        s7: s7 ?? this.s7,
        s8: s8 ?? this.s8,
        s9: s9 ?? this.s9,
        s10: s10 ?? this.s10,
        s12: s12 ?? this.s12,
        s13: s13 ?? this.s13,
        s14: s14 ?? this.s14,
        s15: s15 ?? this.s15,
        s16: s16 ?? this.s16,
        s17: s17 ?? this.s17,
        s18: s18 ?? this.s18,
        s20: s20 ?? this.s20,
        s22: s22 ?? this.s22,
        s28: s28 ?? this.s28,
        s31: s31 ?? this.s31,
        s32: s32 ?? this.s32,
        s36: s36 ?? this.s36,
        s50: s50 ?? this.s50,
        s64: s64 ?? this.s64,
        s70: s70 ?? this.s70,
        s74: s74 ?? this.s74,
        quarter: quarter ?? this.quarter,
        half: half ?? this.half,
        base: base ?? this.base,
      );

  @override
  flutter.ThemeExtension<Sizing> lerp(
    final flutter.ThemeExtension<Sizing>? other,
    final double t,
  ) {
    if (other is! Sizing) {
      return this;
    }
    return Sizing(
      s2: lerpDouble(
            s2,
            other.s2,
            t,
          ) ??
          s2,
      s3: lerpDouble(
            s3,
            other.s3,
            t,
          ) ??
          s3,
      s4: lerpDouble(
            s4,
            other.s4,
            t,
          ) ??
          s4,
      s5: lerpDouble(
            s5,
            other.s5,
            t,
          ) ??
          s5,
      s6: lerpDouble(
            s6,
            other.s6,
            t,
          ) ??
          s6,
      s7: lerpDouble(
            s7,
            other.s7,
            t,
          ) ??
          s7,
      s8: lerpDouble(
            s8,
            other.s8,
            t,
          ) ??
          s8,
      s9: lerpDouble(
            s9,
            other.s9,
            t,
          ) ??
          s9,
      s10: lerpDouble(
            s10,
            other.s10,
            t,
          ) ??
          s10,
      s12: lerpDouble(
            s12,
            other.s12,
            t,
          ) ??
          s12,
      s13: lerpDouble(
            s13,
            other.s13,
            t,
          ) ??
          s13,
      s14: lerpDouble(
            s14,
            other.s14,
            t,
          ) ??
          s14,
      s15: lerpDouble(
            s15,
            other.s15,
            t,
          ) ??
          s15,
      s16: lerpDouble(
            s16,
            other.s16,
            t,
          ) ??
          s16,
      s17: lerpDouble(
            s17,
            other.s17,
            t,
          ) ??
          s17,
      s18: lerpDouble(
            s18,
            other.s18,
            t,
          ) ??
          s18,
      s20: lerpDouble(
            s20,
            other.s20,
            t,
          ) ??
          s20,
      s22: lerpDouble(
            s22,
            other.s22,
            t,
          ) ??
          s22,
      s28: lerpDouble(
            s28,
            other.s28,
            t,
          ) ??
          s28,
      s31: lerpDouble(
            s31,
            other.s31,
            t,
          ) ??
          s31,
      s32: lerpDouble(
            s32,
            other.s32,
            t,
          ) ??
          s32,
      s36: lerpDouble(
            s36,
            other.s36,
            t,
          ) ??
          s36,
      s50: lerpDouble(
            s50,
            other.s50,
            t,
          ) ??
          s50,
      s64: lerpDouble(
            s64,
            other.s64,
            t,
          ) ??
          s64,
      s70: lerpDouble(
            s70,
            other.s70,
            t,
          ) ??
          s70,
      s74: lerpDouble(
            s74,
            other.s74,
            t,
          ) ??
          s74,
      quarter: lerpDouble(
            quarter,
            other.quarter,
            t,
          ) ??
          quarter,
      half: lerpDouble(
            half,
            other.half,
            t,
          ) ??
          half,
      base: lerpDouble(
            base,
            other.base,
            t,
          ) ??
          base,
    );
  }
}
