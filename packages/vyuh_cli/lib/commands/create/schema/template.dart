import 'dart:io';

import 'package:mason/mason.dart';
import 'package:vyuh_cli/commands/create/schema/vyuh_feature_sanity_schema_bundle.dart';
import 'package:vyuh_cli/template.dart';
import 'package:vyuh_cli/utils/utils.dart';

class FeatureSanitySchemaTemplate extends Template {
  FeatureSanitySchemaTemplate()
      : super(
          name: 'schema',
          bundle: vyuhFeatureSanitySchemaBundle,
          help: 'Generate a Vyuh feature Sanity schema.',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDir) async {
    templateSummary(
      logger: logger,
      outputDir: outputDir,
      message: 'Created a Vyuh Feature Sanity schema! 🚀',
    );
  }
}
