import 'dart:async';

import 'package:mason/mason.dart';

abstract base class CliCommand {
  Future<void> run(HookContext context) async {}

  Future<void> trackOperation(
    HookContext context, {
    required String startMessage,
    required String endMessage,
    required Future<void> Function() operation,
  }) async {
    final progress = context.logger.progress(startMessage);

    await operation();

    progress.complete(endMessage);
  }
}
