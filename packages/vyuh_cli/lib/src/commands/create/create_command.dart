import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:vyuh_cli/src/commands/create/commands/index.dart';
import 'package:vyuh_cli/src/commands/create/utils/utils.dart';

class CreateCommand extends Command<int> {
  CreateCommand({
    required Logger logger,
    @visibleForTesting MasonGeneratorFromBundle? generatorFromBundle,
    @visibleForTesting MasonGeneratorFromBrick? generatorFromBrick,
  }) {
    addSubcommand(
      CreateProjectCommand(
        logger: logger,
        generatorFromBundle: generatorFromBundle,
        generatorFromBrick: generatorFromBrick,
      ),
    );
    addSubcommand(
      CreateFeatureCommand(
        logger: logger,
        generatorFromBundle: generatorFromBundle,
        generatorFromBrick: generatorFromBrick,
      ),
    );
    addSubcommand(
      CreateSchemaCommand(
        logger: logger,
        generatorFromBundle: generatorFromBundle,
        generatorFromBrick: generatorFromBrick,
      ),
    );
  }

  @override
  String get summary => '$invocation\n$description';

  @override
  String get description => 'Creates Vyuh projects, features, and CMS schemas.';

  @override
  String get name => 'create';

  @override
  String get invocation => 'vyuh create <subcommand> <item-name> [arguments]';
}
