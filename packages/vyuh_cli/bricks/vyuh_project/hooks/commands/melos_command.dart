import 'dart:async';
import 'dart:io';

import 'package:mason/mason.dart';

import 'cli_command.dart';

final class MelosCommand extends CliCommand {
  @override
  Future<void> run(HookContext context) async {
    final String name = context.vars['name'];
    final appName = name.snakeCase;

    await trackOperation(
      context,
      startMessage: 'Activating Melos globally',
      endMessage: 'Melos activated globally',
      operation: () async {
        await Process.run(
          'dart',
          ['pub', 'global', 'activate', 'melos'],
          runInShell: true,
        );
      },
    );

    await trackOperation(
      context,
      startMessage: 'Running `melos bootstrap` on apps/$appName',
      endMessage: 'Melos bootstrap completed for apps/$appName',
      operation: () async {
        await Process.run(
          'melos',
          ['bootstrap'],
          workingDirectory: appName,
          runInShell: true,
        );
      },
    );
  }
}
