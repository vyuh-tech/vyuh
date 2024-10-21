import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:vyuh_cli/src/commands/create/templates/template.dart';
import 'package:vyuh_cli/src/commands/create/utils/utils.dart';

abstract class FeatureSanitySchemaSubCommand extends Command<int> {
  FeatureSanitySchemaSubCommand({
    required this.logger,
    @visibleForTesting required MasonGeneratorFromBundle? generatorFromBundle,
    @visibleForTesting required MasonGeneratorFromBrick? generatorFromBrick,
  })  : _generatorFromBundle = generatorFromBundle ?? MasonGenerator.fromBundle,
        _generatorFromBrick = generatorFromBrick ?? MasonGenerator.fromBrick {
    argParser
      ..addOption(
        'output-directory',
        abbr: 'o',
        help: 'The desired output directory when creating a new feature.',
      )
      ..addOption(
        'cms',
        help: 'The content management system for this new schema.',
        defaultsTo: defaultCMS,
      );
  }

  final Logger logger;
  final MasonGeneratorFromBundle _generatorFromBundle;
  final MasonGeneratorFromBrick _generatorFromBrick;

  @visibleForTesting
  ArgResults? argResultOverrides;

  Directory get outputDirectory {
    final directory = argResults['output-directory'] as String? ?? '.';
    return Directory(directory);
  }

  String get featureName {
    final args = argResults.rest;
    _validateProjectName(args);
    return args.first;
  }

  String get cms {
    final cms = argResults['cms'] as String? ?? defaultCMS;
    if (cms != defaultCMS) {
      usageException(
        'The CMS "$cms" is not supported. Only "$defaultCMS" is supported at this time.',
      );
    }
    return cms;
  }

  Template get template;

  @override
  String get invocation => 'vyuh create $name <feature-name> [arguments]';

  @override
  ArgResults get argResults => argResultOverrides ?? super.argResults!;

  bool _isValidPackageName(String name) {
    final match = identifierRegExp.matchAsPrefix(name);
    return match != null && match.end == name.length;
  }

  void _validateProjectName(List<String> args) {
    logger.detail('Validating feature name; args: $args');

    if (args.isEmpty) {
      usageException('No option specified for the feature name.');
    }

    if (args.length > 1) {
      usageException('Multiple feature names specified.');
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

    await generator.hooks.preGen(vars: vars, onVarsChanged: (v) => vars = v);
    final _ = await generator.generate(target, vars: vars, logger: logger);
    await generator.hooks.postGen(vars: vars, onVarsChanged: (v) => vars = v);

    await template.onGenerateComplete(
      logger,
      Directory(path.join(target.dir.path, featureName)),
    );

    return ExitCode.success.code;
  }

  @mustCallSuper
  Map<String, dynamic> getTemplateVars() {
    final featureName = this.featureName;
    final cms = this.cms;

    return <String, dynamic>{
      'name': featureName,
      'cms': cms,
    };
  }
}
