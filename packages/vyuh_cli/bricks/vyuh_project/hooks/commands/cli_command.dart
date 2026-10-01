import 'dart:async';
import 'dart:io';

import 'package:mason/mason.dart';

abstract base class CliCommand {
  Future<void> run(HookContext context) async {}

  Future<void> trackOperation(
    HookContext context, {
    required String startMessage,
    required String endMessage,
    required Future<dynamic> Function() operation,
  }) async {
    final progress = context.logger.progress(startMessage);

    try {
      final result = await operation();
      if (result is ProcessResult && result.exitCode != 0) {
        throw StateError(
            '$startMessage failed (exit ${result.exitCode}): ${result.stderr}');
      }
    } catch (_) {
      progress.fail('$startMessage failed');
      rethrow;
    }

    progress.complete(endMessage);
  }
}
