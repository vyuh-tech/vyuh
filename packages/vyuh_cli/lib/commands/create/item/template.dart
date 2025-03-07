import 'dart:io';

import 'package:mason/mason.dart';
import 'package:vyuh_cli/commands/create/item/vyuh_item_bundle.dart';
import 'package:vyuh_cli/template.dart';
import 'package:vyuh_cli/utils/utils.dart';

class ItemTemplate extends Template {
  ItemTemplate()
      : super(
          name: 'item',
          bundle: vyuhItemBundle,
          help: 'Generate a Vyuh ContentItem.',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDir) async {
    templateSummary(
      logger: logger,
      outputDir: outputDir,
      message: 'Created a Vyuh ContentItem! 🚀',
    );
  }
}
