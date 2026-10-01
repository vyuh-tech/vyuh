import 'dart:io';

import 'package:mason/mason.dart';
import 'package:vyuh_cli/commands/create/plugin/vyuh_plugin_bundle.dart';
import 'package:vyuh_cli/template.dart';
import 'package:vyuh_cli/utils/utils.dart';

class PluginTemplate extends Template {
  PluginTemplate()
      : super(
            name: 'plugin',
            bundle: vyuhPluginBundle,
            help: 'Generate a shared capability package.');

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDir) async {
    templateSummary(
        logger: logger,
        outputDir: outputDir,
        message: 'Created a shared capability plugin.');
  }
}
