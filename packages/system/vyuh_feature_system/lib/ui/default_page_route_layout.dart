import 'package:flutter/material.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;

final class DefaultPageRouteLayout extends StatelessWidget {
  final vf.Route content;

  final vf.DefaultRouteLayout layout;

  const DefaultPageRouteLayout(
      {super.key, required this.content, required this.layout});

  @override
  Widget build(BuildContext context) {
    return vf.PageRouteScaffold(
      content: content,
      sliverAppBar: layout.showAppBar
          ? SliverAppBar(
              pinned: true,
              floating: false,
              title: Text(content.title),
              scrolledUnderElevation: 1,
              actions: layout.actions
                  ?.map(
                    (e) => IconButton(
                        onPressed: () => e.action?.execute(context),
                        icon: Icon(e.icon.iconData)),
                  )
                  .toList(growable: false),
            )
          : null,
      useSafeArea: layout.useSafeArea,
    );
  }
}
