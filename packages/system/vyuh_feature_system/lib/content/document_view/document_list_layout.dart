import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'document_list_layout.g.dart';

enum ListViewMode {
  list,
  grid,
}

@JsonSerializable()
final class DefaultDocumentListViewLayout
    extends LayoutConfiguration<DocumentListView> {
  static const schemaName = '${DocumentListView.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Document List View Layout',
    fromJson: DefaultDocumentListViewLayout.fromJson,
  );

  final ListViewMode mode;
  final double aspectRatio;
  final int columns;

  DefaultDocumentListViewLayout({
    this.aspectRatio = 1.0,
    this.mode = ListViewMode.list,
    this.columns = 2,
  }) : super(schemaType: schemaName);

  factory DefaultDocumentListViewLayout.fromJson(Map<String, dynamic> json) =>
      _$DefaultDocumentListViewLayoutFromJson(json);

  @override
  Widget build(BuildContext context, DocumentListView content) {
    return DocumentListViewBuilder(
      list: content,
      builder: (context, items) {
        return CustomScrollView(
          cacheExtent: MediaQuery.sizeOf(context).height * 1.5,
          primary: true,
          slivers: [
            if (mode == ListViewMode.list)
              SliverList.builder(
                itemBuilder: (context, index) => AspectRatio(
                    aspectRatio: aspectRatio,
                    child: content.listItem!.build(context, items[index])),
                itemCount: items.length,
              ),
            if (mode == ListViewMode.grid)
              SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns, childAspectRatio: aspectRatio),
                itemBuilder: (context, index) =>
                    content.listItem!.build(context, items[index]),
                itemCount: items.length,
              )
          ],
        );
      },
    );
  }
}

@JsonSerializable()
final class DocumentListViewConditionalLayout
    extends ConditionalLayout<DocumentListView> {
  static const schemaName = '${DocumentListView.schemaName}.layout.conditional';

  static final typeDescriptor = TypeDescriptor(
    schemaType: DocumentListViewConditionalLayout.schemaName,
    title: 'DocumentListView Conditional Layout',
    fromJson: DocumentListViewConditionalLayout.fromJson,
  );

  DocumentListViewConditionalLayout({
    required super.cases,
    required super.defaultCase,
    required super.condition,
  }) : super(schemaType: schemaName);

  factory DocumentListViewConditionalLayout.fromJson(
          Map<String, dynamic> json) =>
      _$DocumentListViewConditionalLayoutFromJson(json);
}
