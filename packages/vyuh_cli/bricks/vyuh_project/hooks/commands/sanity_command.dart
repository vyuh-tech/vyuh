import 'dart:async';
import 'dart:io';

import 'package:mason/mason.dart';

import 'cli_command.dart';

final class SanityCommand extends CliCommand {
  @override
  Future<void> run(HookContext context) async {
    final String name = context.vars['name'];
    final appName = name.snakeCase;

    final studioName = '${name.paramCase}-studio';

    await trackOperation(
      context,
      startMessage: 'Setting up the Sanity project @ apps/$studioName',
      endMessage: 'Sanity project ready @ apps/$studioName',
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
          workingDirectory: '$appName/apps',
        );

        await Process.run(
          'pnpm',
          [
            'add',
            ...('@vyuh/sanity-schema-core @vyuh/sanity-schema-system @vyuh/sanity-plugin-structure'
                .split(' ')),
          ],
          workingDirectory: '$appName/apps/$studioName',
        );
      },
    );
  }
}
