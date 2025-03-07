import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:vyuh_cli/commands/create/feature/command.dart';
import 'package:vyuh_cli/commands/create/item/command.dart';
import 'package:vyuh_cli/commands/create/project/command.dart';
import 'package:vyuh_cli/commands/create/schema/command.dart';
import 'package:vyuh_cli/utils/utils.dart';

final class CreateCommand extends Command<int> {
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
      CreateSanitySchemaCommand(
        logger: logger,
        generatorFromBundle: generatorFromBundle,
        generatorFromBrick: generatorFromBrick,
      ),
    );
    addSubcommand(
      CreateItemCommand(
        logger: logger,
        generatorFromBundle: generatorFromBundle,
        generatorFromBrick: generatorFromBrick,
      ),
    );
  }

  @override
  String get summary => '$invocation\n$description';

  @override
  String get description => 'Creates Vyuh projects, features, content items, and CMS schemas.';

  @override
  String get name => 'create';

  @override
  String get invocation => 'vyuh create <subcommand> <item-name> [arguments]';
}
