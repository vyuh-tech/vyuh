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
        final sanityCreateResult = await Process.run(
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
          runInShell: true,
        );
        if (sanityCreateResult.exitCode != 0) {
          final error = sanityCreateResult.stderr.toString();
          context.logger.err('Failed to create Sanity Studio: $error');
          exit(1);
        }

        await trackOperation(context,
            startMessage: p.normalize('Adding NPM packages @ apps/$studioName'),
            endMessage: p.normalize('Added NPM packages @ apps/$studioName'),
            operation: () async => Process.run(
                  'pnpm',
                  [
                    'add',
                    ...('@vyuh/sanity-schema-core @vyuh/sanity-schema-system @vyuh/sanity-plugin-structure'
                        .split(' ')),
                  ],
                  workingDirectory: p.normalize('$appName/apps/$studioName'),
                  runInShell: true,
                ));
      },
    );
  }
}
