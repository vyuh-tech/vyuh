import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_plugin_storage_secure/vyuh_plugin_storage_secure.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('secure storage supports a second initialized lifecycle', () async {
    final plugin = FlutterSecureStoragePlugin();
    await plugin.dispose();
    expect(plugin.initialized, isFalse);
    await plugin.init();
    expect(plugin.initialized, isTrue);
    await plugin.dispose();
    expect(plugin.initialized, isFalse);
    await plugin.init();
    expect(plugin.initialized, isTrue);
    await plugin.dispose();
  });
}
