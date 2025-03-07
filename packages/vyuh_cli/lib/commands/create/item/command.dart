import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:vyuh_cli/commands/create/item/template.dart';
import 'package:vyuh_cli/template.dart';
import 'package:vyuh_cli/utils/utils.dart';

final class CreateItemCommand extends Command<int> {
  CreateItemCommand({
    required this.logger,
    required MasonGeneratorFromBundle? generatorFromBundle,
    required MasonGeneratorFromBrick? generatorFromBrick,
  })  : _generatorFromBundle = generatorFromBundle ?? MasonGenerator.fromBundle,
        _generatorFromBrick = generatorFromBrick ?? MasonGenerator.fromBrick {
    argParser.addOption(
      'feature',
      abbr: 'f',
      help:
          'The feature to add the content item to. If not specified, the item will be created without a feature context.',
    );
    argParser.addOption(
      'output-directory',
      abbr: 'o',
      help:
          'Custom output directory for the ContentItem files. Defaults to the feature directory.',
    );
  }

  final Logger logger;
  final MasonGeneratorFromBundle _generatorFromBundle;
  final MasonGeneratorFromBrick _generatorFromBrick;

  @visibleForTesting
  ArgResults? argResultOverrides;

  String? get featureName {
    return argResults['feature'] as String?;
  }

  String? get outputDirectory {
    return argResults['output-directory'] as String?;
  }

  String get itemName {
    final args = argResults.rest;
    _validateItemName(args);
    return args.first;
  }

  @override
  String get name => 'item';

  @override
  String get description => 'Create a new Vyuh ContentItem.';

  Template get template => ItemTemplate();

  @override
  String get invocation =>
      'vyuh create $name <item-name> [--feature <feature-name>] [--output-directory <directory>]';

  @override
  ArgResults get argResults => argResultOverrides ?? super.argResults!;

  bool _isValidItemName(String name) {
    final match = identifierRegExp.matchAsPrefix(name);
    return match != null && match.end == name.length;
  }

  void _validateItemName(List<String> args) {
    logger.detail('Validating item name; args: $args');

    if (args.isEmpty) {
      usageException('No option specified for the item name.');
    }

    if (args.length > 1) {
      usageException('Multiple item names specified.');
    }

    final name = args.first;
    final isValidItemName = _isValidItemName(name);
    if (!isValidItemName) {
      usageException(
        '"$name" is not a valid item name.\n\n'
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

    // Determine the base directory (feature directory, custom output directory, or current directory)
    final Directory baseDir;
    if (outputDirectory != null) {
      // Use specified output directory
      baseDir = Directory(outputDirectory!);
      if (!baseDir.existsSync()) {
        logger.err('Output directory not found: ${baseDir.path}');
        return ExitCode.noInput.code;
      }
    } else if (featureName != null) {
      // Use feature directory if feature name is provided
      baseDir = Directory(
          path.join('features', featureName!, 'feature_$featureName'));
      if (!baseDir.existsSync()) {
        logger.err('Feature directory not found: ${baseDir.path}');
        return ExitCode.noInput.code;
      }
    } else {
      // Default to current directory if neither output directory nor feature name is provided
      baseDir = Directory('.');
      logger.info(
          'No feature or output directory specified. Using current directory.');
    }

    final contentDir = Directory(path.join(baseDir.path, 'lib', 'content'));
    if (!contentDir.existsSync()) {
      contentDir.createSync(recursive: true);
    }

    final target = DirectoryGeneratorTarget(contentDir);

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

    logger.info(
      '''
Don't forget to:
1. Run 'dart run build_runner build' to generate the JSON serialization code
2. Register the ContentBuilder in your FeatureDescriptor with the ContentExtensionDescriptor()
''',
    );

    return ExitCode.success.code;
  }

  @mustCallSuper
  Map<String, dynamic> getTemplateVars() {
    final itemName = this.itemName;
    final featureName = this.featureName;

    return <String, dynamic>{
      'item_name': itemName,
      'feature_name': featureName ??
          'vyuh', // Default to 'vyuh' if no feature name is provided
    };
  }
}
