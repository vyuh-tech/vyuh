import 'dart:io';

import 'package:cli_launcher/cli_launcher.dart';
import 'package:melos/src/command_runner.dart';

/// Use the resolved workspace without `dart run` expanding invalid nested
/// workspace declarations in hosted dependencies such as base_menu.
Future<void> main(List<String> arguments) async => melosEntryPoint(
  arguments,
  LaunchContext(
    directory: Directory.current,
    localInstallation: ExecutableInstallation(
      name: ExecutableName('melos'),
      isSelf: false,
      packageRoot: Directory.current,
    ),
  ),
);
