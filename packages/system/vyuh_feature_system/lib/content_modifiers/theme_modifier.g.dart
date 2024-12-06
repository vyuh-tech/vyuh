// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_modifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeModifier _$ThemeModifierFromJson(Map<String, dynamic> json) =>
    ThemeModifier(
      mode: $enumDecodeNullable(_$ThemeModeEnumMap, json['mode']) ??
          ThemeMode.light,
    );

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
