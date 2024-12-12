import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

    final platform = Theme.of(context).platform;

    switch (platform) {
      case TargetPlatform.android:
        return Future.value('android');
      case TargetPlatform.iOS:
        return Future.value('ios');
      case TargetPlatform.macOS:
        return Future.value('macos');
      case TargetPlatform.windows:
        return Future.value('windows');
      case TargetPlatform.linux:
        return Future.value('linux');
      case TargetPlatform.fuchsia:
        return Future.value('fuchsia');
    }
  }
}
