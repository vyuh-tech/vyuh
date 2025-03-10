import 'dart:async';
import 'dart:io';

import 'package:vyuh_cli/commands/create/base_create_command.dart';
import 'package:vyuh_cli/commands/create/feature/template.dart';
import 'package:vyuh_cli/template.dart';
import 'package:vyuh_cli/utils/utils.dart';

final class CreateFeatureCommand extends BaseCreateCommand {
  CreateFeatureCommand({
    required super.logger,
    required super.generatorFromBundle,
    required super.generatorFromBrick,
  });

  @override
  void setupArgParser() {
    super.setupArgParser();
    // Add feature-specific arguments here if needed
  }

  String get featureName => argResults.rest.first;

  @override
  String get name => 'feature';

  @override
  String get description => 'Create a new Vyuh feature.';

  @override
  Template get template => FeatureTemplate();

  @override
  String get invocation => 'vyuh create $name <feature-name> [arguments]';

  bool _isValidPackageName(String name) {
    final match = identifierRegExp.matchAsPrefix(name);
    return match != null && match.end == name.length;
  }

  void _validateFeatureName(List<String> args) {
    logger.detail('Validating feature name; args: $args');

    if (args.isEmpty) {
      usageException('No option specified for the feature name.');
    }

    if (args.length > 1) {
      usageException('Multiple feature names specified.');
    }

    final name = args.first;
    final isValidFeatureName = _isValidPackageName(name);
    if (!isValidFeatureName) {
      usageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
      );
    }
  }

  @override
  void validateArgs() {
    _validateFeatureName(argResults.rest);
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
    vars['name'] = featureName;
    return vars;
  }
}
