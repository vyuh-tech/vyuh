import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:vyuh_cli/template.dart';
import 'package:vyuh_cli/utils/utils.dart';

/// Base class for all create commands in Vyuh CLI.
abstract class BaseCreateCommand extends Command<int> {
  BaseCreateCommand({
    required this.logger,
    required MasonGeneratorFromBundle? generatorFromBundle,
    required MasonGeneratorFromBrick? generatorFromBrick,
  })  : _generatorFromBundle = generatorFromBundle ?? MasonGenerator.fromBundle,
        _generatorFromBrick = generatorFromBrick ?? MasonGenerator.fromBrick {
    // Configure common arguments here
    setupArgParser();
  }

  final Logger logger;
  final MasonGeneratorFromBundle _generatorFromBundle;
  final MasonGeneratorFromBrick _generatorFromBrick;

  @visibleForTesting
  ArgResults? argResultOverrides;

  /// The template to use for generation
  Template get template;

  /// Sets up the argument parser with command-specific options
  @protected
  void setupArgParser() {
    // Common options for all create commands
    argParser.addOption(
      'output-directory',
      abbr: 'o',
      help: 'Custom output directory for the generated files.',
    );

    // Command-specific options should be added in subclasses
  }

  @override
  ArgResults get argResults => argResultOverrides ?? super.argResults!;

  /// Gets the output directory from arguments
  String? get outputDirectory {
    return argResults['output-directory'] as String?;
  }

  /// Validates command-specific arguments
  @protected
  void validateArgs();

  /// Gets template variables for generation
  @mustCallSuper
  Map<String, dynamic> getTemplateVars() {
    return <String, dynamic>{};
  }

  /// Gets the generator for the template
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

  /// Determines the target directory for generation
  @protected
  Future<Directory> getTargetDirectory();

  /// Runs the command
  @override
  Future<int> run() async {
    validateArgs();

    final generator = await _getGeneratorForTemplate();
    final targetDir = await getTargetDirectory();

    return await runGenerate(generator, targetDir);
  }

  /// Runs the generation process
  Future<int> runGenerate(MasonGenerator generator, Directory targetDir) async {
    var vars = getTemplateVars();

    if (!targetDir.existsSync()) {
      targetDir.createSync(recursive: true);
    }

    final target = DirectoryGeneratorTarget(targetDir);

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
      target.dir,
    );

    return ExitCode.success.code;
  }
}
