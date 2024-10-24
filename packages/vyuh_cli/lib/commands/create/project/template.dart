import 'dart:io';

import 'package:mason/mason.dart';
import 'package:vyuh_cli/commands/create/project/vyuh_project_bundle.dart';
import 'package:vyuh_cli/template.dart';
import 'package:vyuh_cli/utils/utils.dart';

class ProjectTemplate extends Template {
  ProjectTemplate()
      : super(
          name: 'project',
          bundle: vyuhProjectBundle,
          help:
              'Generate a Vyuh Project with a Flutter Application and a Sanity Studio.',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDir) async {
    templateSummary(
      logger: logger,
      outputDir: outputDir,
      message: 'Created a Vyuh Project! 🚀',
    );
  }
}
