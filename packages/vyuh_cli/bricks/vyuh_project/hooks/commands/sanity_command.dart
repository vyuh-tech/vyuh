import 'dart:async';
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;

import 'cli_command.dart';

final class SanityCommand extends CliCommand {
  @override
  Future<void> run(HookContext context) async {
    final String name = context.vars['name'];
    final appName = name.snakeCase;

    final studioName = '${name.paramCase}-studio';

    await trackOperation(
      context,
      startMessage:
          p.normalize('Setting up the Sanity project @ apps/$studioName'),
      endMessage: p.normalize('Sanity project ready @ apps/$studioName'),
      operation: () async {
        await Process.run(
          'pnpm',
          [
            'create',
            'sanity@latest',
            '--yes',
            '--dataset',
            'production',
            '--template',
            'clean',
            '--visibility',
            'public',
            '--create-project',
            studioName,
            '--output-path',
            studioName,
          ],
          workingDirectory: p.normalize('$appName/apps'),
        );

        await Process.run(
          'pnpm',
          [
            'add',
            ...('@vyuh/sanity-schema-core @vyuh/sanity-schema-system @vyuh/sanity-plugin-structure'
                .split(' ')),
          ],
          workingDirectory: p.normalize('$appName/apps/$studioName'),
        );
      },
    );
  }
}
