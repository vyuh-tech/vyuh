import 'dart:async';
import 'dart:io';

import 'package:vyuh_cli/commands/create/base_create_command.dart';
import 'package:vyuh_cli/commands/create/schema/template.dart';
import 'package:vyuh_cli/template.dart';
import 'package:vyuh_cli/utils/utils.dart';

final class CreateSanitySchemaCommand extends BaseCreateCommand {
  CreateSanitySchemaCommand({
    required super.logger,
    required super.generatorFromBundle,
    required super.generatorFromBrick,
  });

  @override
  void setupArgParser() {
    super.setupArgParser();
    argParser.addOption(
      'cms',
      help: 'The content management system for this new schema.',
      defaultsTo: defaultCMS,
    );
  }

  @override
  String get name => 'schema';

  @override
  String get description => 'Create a new Vyuh feature CMS schema.';

  @override
  Template get template => FeatureSanitySchemaTemplate();

  String get featureName => argResults.rest.first;

  String get cms {
    final cms = argResults['cms'] as String? ?? defaultCMS;
    if (cms != defaultCMS) {
      usageException(
        'The CMS "$cms" is not supported. Only "$defaultCMS" is supported at this time.',
      );
    }
    return cms;
  }

  @override
  String get invocation =>
      'vyuh create $name <feature-name> [--output-directory <directory>] [--cms <cms-type>]';

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
    // Validate CMS
    final _ = cms; // This will throw an exception if CMS is not supported
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
    vars.addAll({
      'name': featureName,
      'cms': cms,
    });
    return vars;
  }
}
