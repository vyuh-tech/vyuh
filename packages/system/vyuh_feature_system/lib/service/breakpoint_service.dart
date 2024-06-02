import 'package:flutter/cupertino.dart';

enum Breakpoint {
  small,
  medium,
  large,
  xlarge,
}

class BreakpointConfiguration {
  final double small;
  final double medium;
  final double large;
  final double xlarge;

  BreakpointConfiguration({
    required this.small,
    required this.medium,
    required this.large,
    required this.xlarge,
  });
}

final class BreakpointService {
  static var _config = BreakpointConfiguration(
    small: 450,
    medium: 800,
    large: 1920,
    xlarge: double.infinity,
  );

  BreakpointConfiguration get config => _config;

  BreakpointService();

  static void configure(BreakpointConfiguration config) {
    _config = config;
  }

  Breakpoint getBreakpoint(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final config = _config;
    if (width < config.small) {
      return Breakpoint.small;
    } else if (width < config.medium) {
      return Breakpoint.medium;
    } else if (width < config.large) {
      return Breakpoint.large;
    } else {
      return Breakpoint.xlarge;
    }
  }
}
