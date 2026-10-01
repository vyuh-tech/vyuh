import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mason/mason.dart';

import 'package:vyuh_cli/commands/create/base_create_command.dart';
import 'package:vyuh_cli/commands/create/plugin/template.dart';
import 'package:vyuh_cli/template.dart';
import 'package:vyuh_cli/utils/utils.dart';

final class CreatePluginCommand extends BaseCreateCommand {
  CreatePluginCommand({
    required super.logger,
    required super.generatorFromBundle,
    required super.generatorFromBrick,
  });

  @override
  void setupArgParser() {
    super.setupArgParser();
    argParser
      ..addOption('title', help: 'Plugin display title.')
      ..addOption('description',
          help: 'Capability description.',
          defaultsTo: 'A shared Vyuh capability.')
      ..addOption('class-name',
          help: 'Public plugin class (defaults to <Name>Plugin).');
  }

  String get pluginName => argResults.rest.first;

  @override
  String get name => 'plugin';

  @override
  String get description => 'Create a shared capability plugin package.';

  @override
  Template get template => PluginTemplate();

  @override
  String get invocation => 'vyuh create $name <plugin-name> [arguments]';

  bool _isValidPackageName(String name) {
    final match = identifierRegExp.matchAsPrefix(name);
    return match != null && match.end == name.length;
  }

  void _validatePluginName(List<String> args) {
    logger.detail('Validating plugin name; args: $args');

    if (args.isEmpty) {
      usageException('No option specified for the plugin name.');
    }

    if (args.length > 1) {
      usageException('Multiple plugin names specified.');
    }

    final name = args.first;
    final isValidPluginName = _isValidPackageName(name);
    if (!isValidPluginName) {
      usageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
      );
    }
  }

  @override
  void validateArgs() {
    _validatePluginName(argResults.rest);
    final className = argResults['class-name'] as String?;
    if (className != null &&
        !RegExp(r'^[A-Z][a-zA-Z0-9]*$').hasMatch(className)) {
      usageException('Use a PascalCase class name, such as SearchPlugin.');
    }
  }

  @override
  Future<Directory> getTargetDirectory() async {
    // Use specified output directory or default to current directory
    final directory =
        outputDirectory != null ? Directory(outputDirectory!) : Directory('.');

    return directory;
  }

  @override
  Map<String, dynamic> getTemplateVars() {
    final vars = super.getTemplateVars();
    vars['name'] = pluginName;
    vars['title_literal'] =
        jsonEncode(argResults['title'] ?? pluginName.titleCase);
    vars['description_literal'] = jsonEncode(argResults['description']);
    vars['class_name'] =
        argResults['class-name'] ?? '${pluginName.pascalCase}Plugin';
    return vars;
  }
}
