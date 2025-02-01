import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class DocumentViewBuilder extends StatefulWidget {
  final DocumentView document;
  final Widget Function(BuildContext, List<ContentItem>) builder;
  const DocumentViewBuilder({
    super.key,
    required this.document,
    required this.builder,
  });

  @override
  State<DocumentViewBuilder> createState() => DocumentViewBuilderState();
}

class DocumentViewBuilderState extends State<DocumentViewBuilder> {
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

  static DocumentViewBuilderState of(BuildContext context) {
    final state = context.findAncestorStateOfType<DocumentViewBuilderState>();
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
      child: widget.builder(context, widget.document.items),
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

        return VyuhBinding.instance.content.provider.fetchById(documentId,
            fromJson: VyuhBinding.instance.content.fromJson<DocumentItem>);

      case DocumentLoadStrategy.query:
        final query = content.query?.buildQuery(context);

        if (query == null) {
          return Future.error(StateError(
              'Document query is null for document type: ${content.schemaType}'));
        }

        return VyuhBinding.instance.content.provider.fetchSingle(query,
            fromJson: VyuhBinding.instance.content.fromJson<DocumentItem>);
    }
  }
}
