import 'dart:convert';
import 'dart:io';

import 'package:mason/mason.dart';

/// Every brick, with the folder under `lib/commands/create` that holds its
/// bundle and the name of the bundle variable.
const bricks = {
  'vyuh_feature': ('feature', 'vyuhFeatureBundle'),
  'vyuh_feature_sanity_schema': ('schema', 'vyuhFeatureSanitySchemaBundle'),
  'vyuh_item': ('item', 'vyuhItemBundle'),
  'vyuh_plugin': ('plugin', 'vyuhPluginBundle'),
  'vyuh_project': ('project', 'vyuhProjectBundle'),
};

/// Rewrites the bundle of every brick. Run it from the repository root after
/// changing anything under `packages/vyuh_cli/bricks`, then format the output.
void main() {
  for (final MapEntry(key: brick, value: (folder, variable))
      in bricks.entries) {
    final bundle = createBundle(Directory('packages/vyuh_cli/bricks/$brick'));
    final json = const JsonEncoder.withIndent('  ').convert(bundle.toJson());
    File('packages/vyuh_cli/lib/commands/create/$folder/${brick}_bundle.dart')
        .writeAsStringSync(
          '// GENERATED CODE - DO NOT MODIFY BY HAND.\n'
          "import 'package:mason/mason.dart';\n\n"
          'final $variable = MasonBundle.fromJson(<String, dynamic>$json);\n',
        );
  }
}
