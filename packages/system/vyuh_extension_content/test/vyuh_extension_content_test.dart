import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

void main() {
  test('content extension identifies its registry', () {
    expect(ContentExtensionBuilder().extensionType, ContentExtensionDescriptor);
  });
}
