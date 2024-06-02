import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content/condition.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

final class CurrentThemeMode extends ConditionConfiguration {
  static const schemaName = 'vyuh.condition.themeMode';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: (json) => CurrentThemeMode(),
    title: 'Current Theme Mode',
  );

  CurrentThemeMode() : super(schemaType: schemaName);

  @override
  Future<String?> execute(BuildContext context) {
    final mode = vyuh.di.get<ThemeService>().currentMode.value;

    return Future.value(mode.name);
  }
}
