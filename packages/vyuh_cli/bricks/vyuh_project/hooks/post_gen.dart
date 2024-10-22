import 'dart:async';

import 'package:mason/mason.dart';

import 'commands/flutter_command.dart';
import 'commands/melos_command.dart';
import 'commands/preconditions_check_command.dart';
import 'commands/sanity_command.dart';

Future<void> run(HookContext context) async {
  final cms = context.vars['cms'];
  final commands = [
    PreConditionsCheckCommand(),
    FlutterCommand(),
    MelosCommand(),
    if (cms == 'sanity') SanityCommand(),
  ];

  for (final command in commands) {
    await command.run(context);
  }
}
