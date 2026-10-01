import 'dart:convert';
import 'dart:io';
import 'package:mason/mason.dart';

void main() {
  for (final entry
      in {'vyuh_feature': 'feature', 'vyuh_project': 'project'}.entries) {
    final bundle =
        createBundle(Directory('packages/vyuh_cli/bricks/${entry.key}'));
    final variable =
        entry.key == 'vyuh_feature' ? 'vyuhFeatureBundle' : 'vyuhProjectBundle';
    final json = const JsonEncoder.withIndent('  ').convert(bundle.toJson());
    File('packages/vyuh_cli/lib/commands/create/${entry.value}/${entry.key}_bundle.dart')
        .writeAsStringSync(
      '// GENERATED CODE - DO NOT MODIFY BY HAND.\n'
      "import 'package:mason/mason.dart';\n\n"
      'final $variable = MasonBundle.fromJson(<String, dynamic>$json);\n',
    );
  }
}
