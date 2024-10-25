import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class DetailBuilder<T> extends StatelessWidget {
  final ObservableFuture? Function() futureBuilder;

  final Widget Function(BuildContext context, T data) builder;

  final String? errorTitle;

  final String? errorSubtitle;

  const DetailBuilder({
    super.key,
    required this.futureBuilder,
    required this.builder,
    this.errorTitle,
    this.errorSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final future = futureBuilder();

    if (future == null) {
      return empty;
    }

    if (future.value != null) {
      return builder(context, future.value! as T);
    }

    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return vyuh.widgetBuilder.contentLoader(context);
        }

        if (snapshot.hasError || snapshot.hasData == false) {
          return vyuh.widgetBuilder.errorView(
            context,
            error: snapshot.error,
            title: errorTitle ?? 'Error While Fetching Data',
          );
        }

        return builder(context, snapshot.data! as T);
      },
    );
  }
}
