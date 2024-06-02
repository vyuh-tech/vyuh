import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content/condition.dart';

final class CurrentPlatform extends ConditionConfiguration {
  static const schemaName = 'vyuh.condition.platform';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: (json) => CurrentPlatform(),
    title: 'Current Platform',
  );

  CurrentPlatform() : super(schemaType: schemaName);

  @override
  Future<String?> execute(BuildContext context) {
    if (kIsWeb) {
      return Future.value('web');
    }

    if (Platform.isAndroid) {
      return Future.value('android');
    } else if (Platform.isIOS) {
      return Future.value('ios');
    } else if (Platform.isMacOS) {
      return Future.value('macos');
    } else if (Platform.isWindows) {
      return Future.value('windows');
    } else if (Platform.isLinux) {
      return Future.value('linux');
    } else if (Platform.isFuchsia) {
      return Future.value('fuchsia');
    } else {
      return Future.value(null);
    }
  }
}
