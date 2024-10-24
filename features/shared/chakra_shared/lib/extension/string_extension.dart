import 'package:html/parser.dart' as html_parser;

extension StringExtension on String {
  String get replaceAllSpecialCharacters =>
      replaceAll(RegExp('[^A-Za-z0-9]'), '');

  String parseHtml(String htmlString) {
    final parsedString = html_parser.parse(htmlString);
    return parsedString.body?.text ?? '';
  }
}
