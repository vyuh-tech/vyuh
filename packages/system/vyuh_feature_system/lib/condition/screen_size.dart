import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content/condition.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

/// A condition configuration that evaluates the current screen size breakpoint.
///
/// Features:
/// * Responsive design support
/// * Breakpoint-based evaluation
/// * Integration with [BreakpointService]
/// * Asynchronous evaluation
///
/// Example:
/// ```dart
/// // In a conditional content
/// final conditional = Conditional(
///   condition: Condition(
///     configuration: ScreenSize(),
///   ),
///   cases: [
///     CaseItem(
///       value: 'small',
///       item: MobileLayout(),
///     ),
///     CaseItem(
///       value: 'large',
///       item: DesktopLayout(),
///     ),
///   ],
///   defaultCase: 'small',
/// );
///
/// // In a conditional action
/// final action = ConditionalAction(
///   condition: Condition(
///     configuration: ScreenSize(),
///   ),
///   cases: [
///     ActionCase(
///       value: 'small',
///       action: NavigationAction(url: '/mobile'),
///     ),
///     ActionCase(
///       value: 'large',
///       action: NavigationAction(url: '/desktop'),
///     ),
///   ],
///   defaultCase: 'small',
/// );
/// ```
///
/// The condition returns:
/// * 'small' for mobile devices
/// * 'medium' for tablets
/// * 'large' for desktops
/// * 'xlarge' for large screens
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
