import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart';

void main() {
  test('system plugins cannot bypass their named slot via others', () {
    expect(
      () => PluginDescriptor(others: [GetItDIPlugin()]),
      throwsArgumentError,
    );
    expect(
      () => PluginDescriptor(others: [HttpNetworkPlugin()]),
      throwsArgumentError,
    );
  });
}
