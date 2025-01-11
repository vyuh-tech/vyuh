import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class PreviewContext extends InheritedWidget {
  final ContentItem content;
  final LayoutConfiguration<ContentItem> layout;

  const PreviewContext({
    super.key,
    required this.content,
    required this.layout,
    required super.child,
  });

  static PreviewContext? of(BuildContext context) {
    final previewContext =
        context.dependOnInheritedWidgetOfExactType<PreviewContext>();

    return previewContext;
  }

  @override
  bool updateShouldNotify(PreviewContext oldWidget) {
    return content != oldWidget.content || layout != oldWidget.layout;
  }
}
