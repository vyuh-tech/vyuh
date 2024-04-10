import 'dart:async';
import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final String name = context.vars['name'];
  final String description = context.vars['description'];

  await Process.run(
    'flutter',
    [
      'create',
      '${name.snakeCase}',
      '--template=app',
      '--platforms=ios,android,web',
      '--description=$description',
    ],
    workingDirectory: 'apps',
  );

  await Process.run('melos', ['bootstrap']);
}
