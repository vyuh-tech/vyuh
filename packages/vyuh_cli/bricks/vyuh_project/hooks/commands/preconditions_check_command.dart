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
    final required = [
      'flutter',
      'dart',
      if (context.vars['cms'] == 'sanity') 'pnpm'
    ];
    context.logger.alert(
        'Checking for availability of programs (${required.join(', ')})...');

    for (final program in required) {
      final result = await which(program);

      if (result == null) {
        context.logger.err(programs[program] ??
            '$program is not installed. Add it to your PATH.');
        exit(1);
      }
    }
  }
}
