import 'dart:async';
import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  await _trackOperation(
    context,
    startMessage: 'Running `melos bootstrap`',
    endMessage: 'Melos bootstrap completed',
    operation: () async {
      await Process.run(
        'melos',
        ['bootstrap'],
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
