import 'package:flutter/cupertino.dart';

/// Represents different screen size breakpoints for responsive design.
///
/// The breakpoints are:
/// * [small] - For mobile devices and small screens
/// * [medium] - For tablets and medium-sized screens
/// * [large] - For desktop and large screens
/// * [xLarge] - For extra large screens and TV displays
enum Breakpoint {
  small,
  medium,
  large,
  xLarge,
  xxLarge,
}

/// Configuration for screen size breakpoints used in responsive design.
///
/// Allows customizing the width thresholds for different screen sizes:
/// * [small] - Width threshold for small screens (default: 450)
/// * [medium] - Width threshold for medium screens (default: 800)
/// * [large] - Width threshold for large screens (default: 1920)
/// * [xLarge] - Width threshold for extra large screens
/// * [xxLarge] - Width threshold for giant screens (default: infinity)
class BreakpointConfiguration {
  final double small;
  final double medium;
  final double large;
  final double xLarge;
  final double xxLarge;

  BreakpointConfiguration({
    required this.small,
    required this.medium,
    required this.large,
    required this.xLarge,
    required this.xxLarge,
  });
}

/// Service for managing screen size breakpoints and responsive design.
///
/// This service provides methods to:
/// * Configure custom breakpoint thresholds
/// * Determine the current breakpoint based on screen width
/// * Access the current breakpoint configuration
final class BreakpointService {
  static var _config = BreakpointConfiguration(
    small: 640,
    medium: 768,
    large: 1024,
    xLarge: 1280,
    xxLarge: double.infinity,
  );

  BreakpointConfiguration get config => _config;

  BreakpointService();

  /// Configures custom breakpoint thresholds for the application.
  ///
  /// Example:
  /// ```dart
  /// BreakpointService.configure(BreakpointConfiguration(
  ///   small: 640,
  ///   medium: 768,
  ///   large: 1024,
  ///   xlarge: double.infinity,
  /// ));
  /// ```
  static void configure(BreakpointConfiguration config) {
    _config = config;
  }

  /// Gets the current [Breakpoint] based on the screen width.
  ///
  /// Uses [MediaQuery] to determine the screen width and returns the appropriate
  /// breakpoint based on the configured thresholds.
  ///
  /// Example:
  /// ```dart
  /// final breakpoint = breakpointService.getBreakpoint(context);
  /// if (breakpoint == Breakpoint.small) {
  ///   // Show mobile layout
  /// }
  /// ```
  Breakpoint getBreakpoint(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final config = _config;
    if (width < config.small) {
      return Breakpoint.small;
    } else if (width < config.medium) {
      return Breakpoint.medium;
    } else if (width < config.large) {
      return Breakpoint.large;
    } else if (width < config.xLarge) {
      return Breakpoint.xLarge;
    } else {
      return Breakpoint.xxLarge;
    }
  }
}
