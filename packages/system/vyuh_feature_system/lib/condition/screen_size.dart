import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content/condition.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

final class ScreenSize extends ConditionConfiguration {
  static const schemaName = 'vyuh.condition.screenSize';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: (json) => ScreenSize(),
    title: 'Screen Size',
  );

  ScreenSize() : super(schemaType: schemaName);

  @override
  Future<String?> execute(BuildContext context) {
    final bp = vyuh.di.get<BreakpointService>().getBreakpoint(context);

    return Future.value(bp.name);
  }
}
