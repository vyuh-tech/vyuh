import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:vyuh_cli/commands/create/project/template.dart';
import 'package:vyuh_cli/template.dart';
import 'package:vyuh_cli/utils/utils.dart';

const _defaultOrgName = 'com.example.vyuh';
const _defaultDescription = 'A Vyuh Flutter project created by Vyuh CLI.';

class CreateProjectCommand extends Command<int> {
  CreateProjectCommand({
    required this.logger,
    required MasonGeneratorFromBundle? generatorFromBundle,
    required MasonGeneratorFromBrick? generatorFromBrick,
  })  : _generatorFromBundle = generatorFromBundle ?? MasonGenerator.fromBundle,
        _generatorFromBrick = generatorFromBrick ?? MasonGenerator.fromBrick {
    argParser
      ..addOption(
        'application-id',
        help: 'The bundle identifier on iOS or application id on Android. '
            '(defaults to <org-name>.<project-name>)',
      )
      ..addOption(
        'output-directory',
        abbr: 'o',
        help: 'The desired output directory when creating a new project.',
      )
      ..addOption(
        'description',
        help: 'The description for this new project.',
        aliases: ['desc'],
        defaultsTo: _defaultDescription,
      )
      ..addOption(
        'cms',
        help: 'The content management system for this new project.',
        defaultsTo: defaultCMS,
      )
      ..addOption(
        'org-name',
        help: 'The organization for this new project.',
        defaultsTo: _defaultOrgName,
        aliases: ['org'],
      );
  }

  final Logger logger;
  final MasonGeneratorFromBundle _generatorFromBundle;
  final MasonGeneratorFromBrick _generatorFromBrick;

  @override
  String get name => 'project';

  @override
  String get description => 'Create a new Vyuh project in Flutter.';

  Template get template => ProjectTemplate();

  @visibleForTesting
  ArgResults? argResultOverrides;

  Directory get outputDirectory {
    final directory = argResults['output-directory'] as String? ?? '.';
    return Directory(directory);
  }

  String get projectName {
    final args = argResults.rest;
    _validateProjectName(args);
    return args.first;
  }

  String get projectDescription => argResults['description'] as String? ?? '';

  String get cms => argResults['cms'] as String? ?? defaultCMS;

  @override
  String get invocation => 'vyuh create $name <project-name> [arguments]';

  @override
  ArgResults get argResults => argResultOverrides ?? super.argResults!;

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

  Future<MasonGenerator> _getGeneratorForTemplate() async {
    try {
      final brick = Brick.version(
        name: template.bundle.name,
        version: '^${template.bundle.version}',
      );
      logger.detail(
        '''Building generator from brick: ${brick.name} ${brick.location.version}''',
      );
      return await _generatorFromBrick(brick);
    } catch (error) {
      logger.detail('Building generator from brick failed: $error');
    }
    logger.detail(
      '''Building generator from bundle ${template.bundle.name} ${template.bundle.version}''',
    );
    return _generatorFromBundle(template.bundle);
  }

  @override
  Future<int> run() async {
    final template = this.template;
    final generator = await _getGeneratorForTemplate();
    final result = await runCreate(generator, template);

    return result;
  }

  Future<int> runCreate(MasonGenerator generator, Template template) async {
    var vars = getTemplateVars();

    final target = DirectoryGeneratorTarget(outputDirectory);

    await generator.hooks.preGen(
      vars: vars,
      onVarsChanged: (v) => vars = v,
      workingDirectory: target.dir.path,
      logger: logger,
    );

    final _ = await generator.generate(target, vars: vars, logger: logger);

    await generator.hooks.postGen(
      vars: vars,
      onVarsChanged: (v) => vars = v,
      workingDirectory: target.dir.path,
      logger: logger,
    );

    await template.onGenerateComplete(
      logger,
      Directory(path.join(target.dir.path, projectName)),
    );

    return ExitCode.success.code;
  }

  Map<String, dynamic> getTemplateVars() {
    final projectName = this.projectName;
    final projectDescription = this.projectDescription;
    final cms = this.cms;
    final applicationId = argResults['application-id'] as String?;

    return <String, dynamic>{
      'name': projectName,
      'description': projectDescription,
      'cms': cms,
      'org_name': orgName,
      if (applicationId != null) 'application_id': applicationId
    };
  }
}

extension on CreateProjectCommand {
  String get orgName {
    final orgName = argResults['org-name'] as String? ?? _defaultOrgName;
    _validateOrgName(orgName);
    return orgName;
  }

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
        '(ex. vyuh.tech.org)',
      );
    }
  }

  bool _isValidOrgName(String name) {
    return orgNameRegExp.hasMatch(name);
  }
}
