import 'dart:ui';

import 'package:flutter/material.dart' as flutter;

class Spacing extends flutter.ThemeExtension<Spacing> {
  final double s0;
  final double s1;
  final double s2;
  final double s4;
  final double s8;
  final double s12;
  final double s16;
  final double s20;
  final double s24;
  final double s32;
  final double s40;
  final double s48;
  final double s56;
  final double s64;
  final double s72;
  final double s80;

  const Spacing({
    this.s0 = 0.0,
    this.s1 = 1.0,
    this.s2 = 2.0,
    this.s4 = 4.0,
    this.s8 = 8.0,
    this.s12 = 12.0,
    this.s16 = 16.0,
    this.s20 = 20.0,
    this.s24 = 24.0,
    this.s32 = 32.0,
    this.s40 = 40.0,
    this.s48 = 48.0,
    this.s56 = 56.0,
    this.s64 = 64.0,
    this.s72 = 72.0,
    this.s80 = 80.0,
  });

  @override
  flutter.ThemeExtension<Spacing> copyWith({
    final double? s0,
    final double? s1,
    final double? s2,
    final double? s4,
    final double? s8,
    final double? s12,
    final double? s16,
    final double? s20,
    final double? s24,
    final double? s32,
    final double? s40,
    final double? s48,
    final double? s56,
    final double? s64,
    final double? s72,
    final double? s80,
  }) =>
      Spacing(
        s0: s0 ?? this.s0,
        s1: s1 ?? this.s1,
        s2: s2 ?? this.s2,
        s4: s4 ?? this.s4,
        s8: s8 ?? this.s8,
        s12: s12 ?? this.s12,
        s16: s16 ?? this.s16,
        s20: s20 ?? this.s20,
        s24: s24 ?? this.s24,
        s32: s32 ?? this.s32,
        s40: s40 ?? this.s40,
        s48: s48 ?? this.s48,
        s56: s56 ?? this.s56,
        s64: s64 ?? this.s64,
        s72: s72 ?? this.s72,
        s80: s80 ?? this.s80,
      );

  @override
  flutter.ThemeExtension<Spacing> lerp(
    final flutter.ThemeExtension<Spacing>? other,
    final double t,
  ) {
    if (other is! Spacing) {
      return this;
    }
    return Spacing(
      s0: lerpDouble(
            s0,
            other.s0,
            t,
          ) ??
          s0,
      s1: lerpDouble(
            s1,
            other.s1,
            t,
          ) ??
          s1,
      s2: lerpDouble(
            s2,
            other.s2,
            t,
          ) ??
          s2,
      s4: lerpDouble(
            s4,
            other.s4,
            t,
          ) ??
          s4,
      s8: lerpDouble(
            s8,
            other.s8,
            t,
          ) ??
          s8,
      s12: lerpDouble(
            s12,
            other.s12,
            t,
          ) ??
          s12,
      s16: lerpDouble(
            s16,
            other.s16,
            t,
          ) ??
          s16,
      s20: lerpDouble(
            s20,
            other.s20,
            t,
          ) ??
          s20,
      s24: lerpDouble(
            s24,
            other.s24,
            t,
          ) ??
          s24,
      s32: lerpDouble(
            s32,
            other.s32,
            t,
          ) ??
          s32,
      s40: lerpDouble(
            s40,
            other.s40,
            t,
          ) ??
          s40,
      s48: lerpDouble(
            s48,
            other.s48,
            t,
          ) ??
          s48,
      s56: lerpDouble(
            s56,
            other.s56,
            t,
          ) ??
          s56,
      s64: lerpDouble(
            s64,
            other.s64,
            t,
          ) ??
          s64,
      s72: lerpDouble(
            s72,
            other.s72,
            t,
          ) ??
          s72,
      s80: lerpDouble(
            s80,
            other.s80,
            t,
          ) ??
          s80,
    );
  }
}
