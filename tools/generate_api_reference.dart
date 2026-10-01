import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as p;

String doc(AnnotatedNode node) =>
    node.documentationComment?.tokens
        .map((t) => t.lexeme.replaceFirst(RegExp(r'^/// ?'), ''))
        .join('\n') ??
    '';
String compact(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim();
String signature(AstNode node, String text) {
  if (node is EnumDeclaration) {
    return 'enum ${node.namePart.typeName} { ${node.body.constants.map((c) => c.name.lexeme).join(', ')} }';
  }
  if (node is MethodDeclaration) {
    return compact(
      '${node.isStatic ? 'static ' : ''}${node.returnType ?? 'dynamic'} ${node.propertyKeyword ?? ''} ${node.name.lexeme}${node.typeParameters ?? ''}${node.parameters ?? ''}',
    );
  }
  if (node is ConstructorDeclaration) {
    return compact(
      '${node.constKeyword ?? ''}${node.factoryKeyword ?? ''} ${node.typeName}${node.name == null ? '' : '.${node.name}'}${node.parameters}',
    );
  }
  if (node is FunctionDeclaration) {
    return compact(
      '${node.returnType ?? 'dynamic'} ${node.propertyKeyword ?? ''} ${node.name}${node.functionExpression.typeParameters ?? ''}${node.functionExpression.parameters ?? ''}',
    );
  }
  if (node is FieldDeclaration) {
    return compact(
      '${node.isStatic ? 'static ' : ''}${node.fields.keyword ?? ''} ${node.fields.type ?? 'dynamic'} ${node.fields.variables.map((v) => v.name.lexeme).where((name) => !name.startsWith('_')).join(', ')}',
    );
  }
  final start = node is AnnotatedNode
      ? node.firstTokenAfterCommentAndMetadata.offset
      : node.offset;
  return compact(text.substring(start, node.end).split(RegExp(r'\s*\{')).first);
}

void main(List<String> args) {
  final root = p.normalize(p.absolute(args.first));
  final output = <Map<String, dynamic>>[];
  for (final category in ['system', 'sanity', 'plugins', '']) {
    final dir = Directory(p.join(root, 'packages', category));
    if (!dir.existsSync()) continue;
    for (final package in dir.listSync().whereType<Directory>()) {
      final pub = File(p.join(package.path, 'pubspec.yaml'));
      final lib = Directory(p.join(package.path, 'lib'));
      if (!pub.existsSync() || !lib.existsSync()) continue;
      final name = RegExp(
        r'^name:\s*(\S+)',
        multiLine: true,
      ).firstMatch(pub.readAsStringSync())!.group(1)!;
      final visited = <String>{};
      final symbols = <Map<String, dynamic>>[];
      void read(String path) {
        path = p.normalize(path);
        if (!visited.add(path) ||
            !File(path).existsSync() ||
            path.endsWith('.g.dart')) {
          return;
        }
        final text = File(path).readAsStringSync();
        final parsed = parseString(
          content: text,
          path: path,
          throwIfDiagnostics: false,
        );
        final unit = parsed.unit;
        for (final d in unit.directives) {
          if (d is ExportDirective) {
            final uri = d.uri.stringValue!;
            if (!uri.startsWith('package:') && !uri.startsWith('dart:')) {
              read(p.join(p.dirname(path), uri));
            }
          }
          if (d is PartDirective) {
            read(p.join(p.dirname(path), d.uri.stringValue!));
          }
        }
        for (final node in unit.declarations) {
          String? symbol;
          List<ClassMember> members = [];
          if (node is ClassDeclaration) {
            symbol = node.namePart.typeName.lexeme;
            members = node.body.members.toList();
          } else if (node is EnumDeclaration) {
            symbol = node.namePart.typeName.lexeme;
            members = node.body.members.toList();
          } else if (node is ExtensionDeclaration) {
            symbol = node.name?.lexeme;
            members = node.body.members.toList();
          } else if (node is MixinDeclaration) {
            symbol = node.name.lexeme;
            members = node.body.members.toList();
          } else if (node is FunctionDeclaration) {
            symbol = node.name.lexeme;
          } else if (node is GenericTypeAlias) {
            symbol = node.name.lexeme;
          } else if (node is TopLevelVariableDeclaration) {
            symbol = node.variables.variables.first.name.lexeme;
          }
          if (symbol == null || symbol.startsWith('_')) continue;
          final api = <Map<String, String>>[];
          for (final m in members) {
            if (m is MethodDeclaration && m.name.lexeme.startsWith('_')) {
              continue;
            }
            if (m is ConstructorDeclaration &&
                (m.name?.lexeme.startsWith('_') ?? false)) {
              continue;
            }
            if (m is FieldDeclaration &&
                m.fields.variables.every(
                  (v) => v.name.lexeme.startsWith('_'),
                )) {
              continue;
            }
            api.add({'signature': signature(m, text), 'doc': doc(m)});
          }
          symbols.add({
            'name': symbol,
            'file': p.relative(path, from: root),
            'line': parsed.lineInfo.getLocation(node.offset).lineNumber,
            'doc': doc(node),
            'signature': signature(node, text),
            'members': api,
          });
        }
      }

      // Every top-level Dart library is an explicitly importable public entry point.
      for (final file in lib.listSync().whereType<File>().where(
        (f) => f.path.endsWith('.dart'),
      )) {
        read(file.path);
      }
      symbols.sort(
        (a, b) => (a['name'] as String).compareTo(b['name'] as String),
      );
      output.add({
        'name': name,
        'path': p.relative(package.path, from: root),
        'symbols': symbols,
      });
    }
  }
  File(
    args[1],
  ).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(output));
  stdout.writeln(
    '${output.length} packages, ${output.fold<int>(0, (n, p) => n + (p['symbols'] as List).length)} public declarations',
  );
}
