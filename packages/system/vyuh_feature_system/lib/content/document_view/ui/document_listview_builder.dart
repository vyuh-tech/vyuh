import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class DocumentListViewBuilder extends StatefulWidget {
  final DocumentListView list;
  final Widget Function(BuildContext context, List<DocumentItem> items) builder;
  const DocumentListViewBuilder(
      {super.key, required this.list, required this.builder});

  @override
  State<DocumentListViewBuilder> createState() =>
      _DocumentListViewBuilderState();
}

class _DocumentListViewBuilderState extends State<DocumentListViewBuilder> {
  final _documentFuture =
      Observable(ObservableFuture<List<DocumentItem>?>(Future.value(null)));

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      runInAction(() => _documentFuture.value =
          ObservableFuture(_fetchDocuments(context, widget.list.query!)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final snapshot = _documentFuture.value;
      if (snapshot.status == FutureStatus.pending) {
        return vyuh.widgetBuilder.contentLoader(context);
      }

      if (snapshot.result == FutureStatus.rejected ||
          (snapshot.status == FutureStatus.fulfilled &&
              (snapshot.result == null || snapshot.result!.isEmpty))) {
        return vyuh.widgetBuilder.errorView(
          context,
          title: 'No documents found',
          error: snapshot.error,
        );
      }

      final height = MediaQuery.sizeOf(context).height;
      final insets = MediaQuery.viewInsetsOf(context);

      final items = snapshot.result! as List<DocumentItem>;

      return LimitedBox(
        maxHeight: height - insets.vertical,
        child: widget.builder(context, items),
      );
    });
  }

  Future<List<DocumentItem>?> _fetchDocuments(
      BuildContext context, QueryConfiguration queryConfig) {
    final query = queryConfig.buildQuery(context);
    if (query == null) {
      return Future.error(StateError(
          'Document query is null for document list type: ${widget.list.schemaType}'));
    }

    return vyuh.content.provider
        .fetchMultiple(query, fromJson: vyuh.content.fromJson<DocumentItem>);
  }
}
