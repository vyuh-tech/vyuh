import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('light and dark themes have matching brightness', () {
    expect(DesignSystem.lightTheme.brightness, Brightness.light);
    expect(DesignSystem.darkTheme.brightness, Brightness.dark);
  });
}
