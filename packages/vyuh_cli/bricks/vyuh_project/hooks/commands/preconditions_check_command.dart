import 'dart:io';

import 'package:mason/mason.dart';
import 'package:process_run/which.dart';

import 'cli_command.dart';

final programs = {
  'pnpm': '''
pnpm is not installed. Please install pnpm and include it in your shell PATH.
Refer to https://pnpm.io/installation for installation instructions.
''',
  'sanity': '''
The Sanity CLI is not installed. Please install the Sanity CLI and include it in your shell PATH.
You also need to login using the "sanity login" command. This is necessary to create a project.

Refer to https://www.sanity.io/docs/cli for installation instructions.  
''',
};

final class PreConditionsCheckCommand extends CliCommand {
  @override
  Future<void> run(HookContext context) async {
    context.logger.alert(
        'Checking for availability of programs (${programs.keys.join(', ')})...');

    for (final program in programs.keys) {
      final result = await which(program);

      if (result == null) {
        context.logger.err(programs[program]);
        exit(1);
      }
    }
  }
}
