import 'dart:async';
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:vyuh_cli/commands/create/base_create_command.dart';
import 'package:vyuh_cli/commands/create/item/template.dart';
import 'package:vyuh_cli/template.dart';
import 'package:vyuh_cli/utils/utils.dart';

final class CreateItemCommand extends BaseCreateCommand {
  CreateItemCommand({
    required super.logger,
    required super.generatorFromBundle,
    required super.generatorFromBrick,
  });

  @override
  void setupArgParser() {
    super.setupArgParser();
    argParser.addOption(
      'feature',
      abbr: 'f',
      help:
          'The feature to add the content item to. If not specified, the item will be created without a feature context.',
    );
  }

  String? get featureName {
    return argResults['feature'] as String?;
  }

  String get itemName => argResults.rest.first;

  @override
  String get name => 'item';

  @override
  String get description => 'Create a new Vyuh ContentItem.';

  @override
  Template get template => ItemTemplate();

  @override
  String get invocation => 'vyuh create $name <item-name> [arguments]';

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

  @override
  void validateArgs() {
    _validateItemName(argResults.rest);
    // Add any additional validations here if needed in the future
  }

  @override
  Future<Directory> getTargetDirectory() async {
    // Determine the base directory (feature directory, custom output directory, or current directory)
    final Directory baseDir;
    if (outputDirectory != null) {
      // Use specified output directory
      baseDir = Directory(outputDirectory!);
      if (!baseDir.existsSync()) {
        logger.err('Output directory not found: ${baseDir.path}');
        throw Exception('Output directory not found: ${baseDir.path}');
      }
    } else if (featureName != null) {
      // Use feature directory if feature name is provided
      baseDir = Directory(
          path.join('features', featureName!, 'feature_$featureName'));
      if (!baseDir.existsSync()) {
        logger.err('Feature directory not found: ${baseDir.path}');
        throw Exception('Feature directory not found: ${baseDir.path}');
      }
    } else {
      // Default to current directory if neither output directory nor feature name is provided
      baseDir = Directory('.');
      logger.info(
          'No feature or output directory specified. Using current directory.');
    }

    final contentDir = Directory(path.join(baseDir.path, 'lib', 'content'));
    return contentDir;
  }

  @override
  Map<String, dynamic> getTemplateVars() {
    final vars = super.getTemplateVars();
    vars['item_name'] = itemName;
    vars['feature_name'] = featureName ?? 'vyuh';
    return vars;
  }

  @override
  Future<int> runGenerate(MasonGenerator generator, Directory targetDir) async {
    final result = await super.runGenerate(generator, targetDir);

    if (result == ExitCode.success.code) {
      logger.info(
        '''
Don't forget to:
1. Run 'dart run build_runner build' to generate the JSON serialization code
2. Register the ContentBuilder in your FeatureDescriptor with the ContentExtensionDescriptor()
''',
      );
    }

    return result;
  }
}
