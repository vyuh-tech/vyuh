library;

import 'package:design_system/core/index.dart' as core;
import 'package:design_system/generated/theme.dart';
import 'package:design_system/utils/extensions.dart';
import 'package:flutter/material.dart';

export 'core/index.dart';
export 'generated/theme.dart';
export 'utils/extensions.dart';

class DesignSystem {
  static ThemeData get lightTheme => MaterialTheme(core.createTextTheme())
      .lightMediumContrast()
      .withExtensions;

  static ThemeData get darkTheme =>
      MaterialTheme(core.createTextTheme()).darkMediumContrast().withExtensions;
}
