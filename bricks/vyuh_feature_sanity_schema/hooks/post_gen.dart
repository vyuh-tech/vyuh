import 'dart:async';
import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final String name = context.vars['name'];
  final folderName = name.camelCase;

  await _trackOperation(
    context,
    startMessage: 'Running pnpm install',
    endMessage: 'pnpm install completed',
    operation: () async {
      await Process.run(
        'pnpm',
        [
          'install',
        ],
        workingDirectory: folderName,
      );
    },
  );
}

Future<void> _trackOperation(
  HookContext context, {
  required String startMessage,
  required String endMessage,
  required Future<void> Function() operation,
}) async {
  final progress = context.logger.progress(startMessage);

  await operation();

  progress.complete(endMessage);
}
