import 'package:vyuh_cli/src/commands/create/commands/project/index.dart';
import 'package:vyuh_cli/src/commands/create/templates/index.dart';

class CreateProjectCommand extends ProjectSubCommand with OrgName {
  CreateProjectCommand({
    required super.logger,
    required super.generatorFromBundle,
    required super.generatorFromBrick,
  }) {
    argParser.addOption(
      'application-id',
      help: 'The bundle identifier on iOS or application id on Android. '
          '(defaults to <org-name>.<project-name>)',
    );
  }

  @override
  String get name => 'project';

  @override
  String get description => 'Create a new Vyuh project in Flutter.';

  @override
  Map<String, dynamic> getTemplateVars() {
    final vars = super.getTemplateVars();

    final applicationId = argResults['application-id'] as String?;
    if (applicationId != null) {
      vars['application_id'] = applicationId;
    }

    return vars;
  }

  @override
  Template get template => ProjectTemplate();
}
