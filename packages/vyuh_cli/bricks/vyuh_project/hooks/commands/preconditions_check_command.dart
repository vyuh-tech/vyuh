import 'dart:io';

import 'package:mason/mason.dart';
import 'package:process_run/which.dart';

import 'cli_command.dart';

final class PreConditionsCheckCommand extends CliCommand {
  @override
  Future<void> run(HookContext context) async {
    final result = await which('pnpm');

    if (result == null) {
      context.logger.err('''
pnpm is not installed. Please install pnpm and include it in your shell PATH.
Refer to https://pnpm.io/installation for installation instructions.''');
      exit(1);
    }
  }
}
