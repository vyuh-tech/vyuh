import 'package:vyuh_cli/src/commands/create/commands/schema/index.dart';
import 'package:vyuh_cli/src/commands/create/templates/index.dart';

class CreateSchemaCommand extends FeatureSanitySchemaSubCommand {
  CreateSchemaCommand({
    required super.logger,
    required super.generatorFromBundle,
    required super.generatorFromBrick,
  });

  @override
  String get name => 'schema';

  @override
  String get description => 'Create a new Vyuh feature CMS schema.';

  @override
  Template get template => FeatureSanitySchemaTemplate();
}
