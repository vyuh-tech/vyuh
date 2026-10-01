import 'package:flutter_test/flutter_test.dart';
import 'package:{{name.snakeCase()}}/{{name.snakeCase()}}.dart';

void main() {
  test('plugin supports initialization, disposal, and reuse', () async {
    final plugin = {{class_name}}();
    await plugin.init();
    expect(plugin.initialized, isTrue);
    await plugin.dispose();
    expect(plugin.initialized, isFalse);
    await plugin.init();
    await plugin.dispose();
  });
}
