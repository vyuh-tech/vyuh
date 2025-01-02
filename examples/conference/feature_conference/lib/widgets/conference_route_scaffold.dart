import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

class ConferenceRouteScaffold<T> extends StatelessWidget {
  final Future<T?> future;
  final Widget Function(BuildContext context, T data) builder;
  final String errorTitle;

  const ConferenceRouteScaffold({
    super.key,
    required this.future,
    required this.builder,
    this.errorTitle = 'Failed to load content',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<T?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return builder(context, snapshot.data as T);
          } else if (snapshot.hasError) {
            return vyuh.widgetBuilder.errorView(
              context,
              title: errorTitle,
              error: snapshot.error!,
            );
          } else {
            return vyuh.widgetBuilder.contentLoader(context);
          }
        },
      ),
    );
  }
}

class ConferenceRouteCustomScrollView extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget sliver;
  final List<Widget>? appBarActions;

  const ConferenceRouteCustomScrollView({
    super.key,
    required this.title,
    this.subtitle,
    this.appBarActions,
    required this.sliver,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        ConferenceRouteSliverAppBar(
          title: title,
          subtitle: subtitle,
          actions: appBarActions,
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: sliver,
          ),
        )
      ],
    );
  }
}

class ConferenceRouteSliverAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  const ConferenceRouteSliverAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      floating: false,
      pinned: true,
      actions: actions,
      title: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: theme.textTheme.labelMedium?.apply(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
        ],
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
