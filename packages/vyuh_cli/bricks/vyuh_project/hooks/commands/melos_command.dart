import 'dart:async';
import 'dart:io';
import 'package:mason/mason.dart';
import 'cli_command.dart';

final class MelosCommand extends CliCommand {
  @override
  Future<void> run(HookContext context) async {
    final String name = context.vars['name'];
    await trackOperation(context,
        startMessage: 'Bootstrapping the feature workspace',
        endMessage: 'Feature workspace ready',
        operation: () => Process.run('dart', ['run', 'melos', 'bootstrap'],
            workingDirectory: name.snakeCase, runInShell: true));
  }
}
