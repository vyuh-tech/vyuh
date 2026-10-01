import 'dart:async';
import 'dart:io';

import 'package:vyuh_cli/commands/create/base_create_command.dart';
import 'package:vyuh_cli/commands/create/project/template.dart';
import 'package:vyuh_cli/template.dart';
import 'package:vyuh_cli/utils/utils.dart';

const _defaultOrgName = 'com.example.vyuh';
const _defaultDescription = 'A Vyuh Flutter project created by Vyuh CLI.';

class CreateProjectCommand extends BaseCreateCommand {
  CreateProjectCommand({
    required super.logger,
    required super.generatorFromBundle,
    required super.generatorFromBrick,
  });

  @override
  void setupArgParser() {
    super.setupArgParser();
    argParser
      ..addOption(
        'application-id',
        help: 'The bundle identifier on iOS or application id on Android. '
            '(defaults to <org-name>.<project-name>)',
      )
      ..addOption(
        'description',
        help: 'The description for this new project.',
        aliases: ['desc'],
        defaultsTo: _defaultDescription,
      )
      ..addOption(
        'cms',
        help: 'Optional CMS integration. No CMS is installed by default.',
        defaultsTo: defaultCMS,
        allowed: ['none', 'sanity'],
      )
      ..addMultiOption('platforms',
          defaultsTo: ['ios', 'android', 'web'],
          allowed: ['ios', 'android', 'web', 'macos', 'windows', 'linux'],
          help: 'Flutter target platforms.')
      ..addOption(
        'org-name',
        help: 'The organization for this new project.',
        defaultsTo: _defaultOrgName,
        aliases: ['org'],
      );
  }

  @override
  String get name => 'project';

  @override
  String get description => 'Create a new Vyuh project in Flutter.';

  @override
  Template get template => ProjectTemplate();

  String get projectName => argResults.rest.first;

  String get projectDescription => argResults['description'] as String? ?? '';

  String get cms => argResults['cms'] as String? ?? defaultCMS;

  String get orgName => argResults['org-name'] as String? ?? _defaultOrgName;

  @override
  String get invocation => 'vyuh create $name <project-name> [arguments]';

  bool _isValidPackageName(String name) {
    final match = identifierRegExp.matchAsPrefix(name);
    return match != null && match.end == name.length;
  }

  void _validateProjectName(List<String> args) {
    logger.detail('Validating project name; args: $args');

    if (args.isEmpty) {
      usageException('No option specified for the project name.');
    }

    if (args.length > 1) {
      usageException('Multiple project names specified.');
    }

    final name = args.first;
    final isValidProjectName = _isValidPackageName(name);
    if (!isValidProjectName) {
      usageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
      );
    }
  }

  @override
  void validateArgs() {
    _validateProjectName(argResults.rest);
    _validateOrgName(orgName);
    if ((argResults['platforms'] as List<String>).isEmpty) {
      usageException('Choose at least one target platform.');
    }
    final id = argResults['application-id'] as String?;
    if (id != null &&
        !RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*(?:\.[a-zA-Z][a-zA-Z0-9_]*)+$')
            .hasMatch(id)) {
      usageException(
          'Use a dotted application identifier, such as com.example.catalog.');
    }
  }

  @override
  Future<Directory> getTargetDirectory() async {
    // Use specified output directory or default to current directory
    final directory =
        outputDirectory != null ? Directory(outputDirectory!) : Directory('.');

    return directory;
  }

  // No need to override runGenerate - the base implementation handles generation
  // Any project-specific post-generation steps should be in the ProjectTemplate.onGenerateComplete method

  void _validateOrgName(String name) {
    logger.detail('Validating org name; $name');
    final isValidOrgName = _isValidOrgName(name);
    if (!isValidOrgName) {
      usageException(
        '"$name" is not a valid org name.\n\n'
        'A valid org name has at least 2 parts separated by "."\n'
        'Each part must start with a letter and only include '
        'alphanumeric characters (A-Z, a-z, 0-9), underscores (_), '
        'and hyphens (-)\n'
        '(eg. vyuh.tech)',
      );
    }
  }

  bool _isValidOrgName(String name) {
    return orgNameRegExp.hasMatch(name);
  }

  @override
  Map<String, dynamic> getTemplateVars() {
    final vars = super.getTemplateVars();
    final projectName = this.projectName;
    final projectDescription = this.projectDescription;
    final cms = this.cms;
    final applicationId = argResults['application-id'] as String?;

    vars.addAll({
      'name': projectName,
      'description': projectDescription,
      'cms': cms,
      'org_name': orgName,
      'platforms': (argResults['platforms'] as List<String>).join(','),
      if (applicationId != null) 'application_id': applicationId
    });

    return vars;
  }
}
