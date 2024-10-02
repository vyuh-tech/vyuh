import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class DocumentViewWidget extends StatefulWidget {
  final DocumentView document;
  const DocumentViewWidget({super.key, required this.document});

  @override
  State<DocumentViewWidget> createState() => DocumentViewWidgetState();
}

class DocumentViewWidgetState extends State<DocumentViewWidget> {
  final _documentFuture =
      Observable(ObservableFuture<DocumentItem?>(Future.value(null)));

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      runInAction(() => _documentFuture.value =
          ObservableFuture(_fetchDocument(context, widget.document)));
    });
  }

  ObservableFuture<T?> document<T extends DocumentItem>() =>
      _documentFuture.value as ObservableFuture<T?>;

  static DocumentViewWidgetState of(BuildContext context) {
    final state = context.findAncestorStateOfType<DocumentViewWidgetState>();
    if (state == null) {
      throw Exception('DocumentViewWidgetState not found in the widget tree');
    }

    return state;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final insets = MediaQuery.viewInsetsOf(context);

    return LimitedBox(
      maxHeight: height - insets.vertical,
      child: ContentItemsScrollView(items: widget.document.items),
    );
  }

  Future<DocumentItem?> _fetchDocument(
      BuildContext context, DocumentView content) {
    switch (content.loadStrategy) {
      case DocumentLoadStrategy.reference:
        final documentId = content.reference?.ref;
        if (documentId == null) {
          return Future.error(StateError(
              'Document ID is null for document type: ${content.schemaType}'));
        }

        return vyuh.content.provider.fetchById(documentId,
            fromJson: vyuh.content.fromJson<DocumentItem>);

      case DocumentLoadStrategy.query:
        final query = content.query?.buildQuery(context);

        if (query == null) {
          return Future.error(StateError(
              'Document query is null for document type: ${content.schemaType}'));
        }

        return vyuh.content.provider
            .fetchSingle(query, fromJson: vyuh.content.fromJson<DocumentItem>);
    }
  }
}
