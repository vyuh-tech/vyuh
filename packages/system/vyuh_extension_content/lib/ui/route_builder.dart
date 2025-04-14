import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'document_builder.dart';

final class RouteBuilder extends StatelessWidget {
  final Uri? url;
  final String? routeId;
  final bool includeDrafts;
  final bool allowRefresh;
  final bool isLive;

  const RouteBuilder({
    super.key,
    this.url,
    this.routeId,
    this.includeDrafts = false,
    this.allowRefresh = true,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return DocumentBuilder.fromRoute(
      url: url,
      routeId: routeId,
      includeDrafts: includeDrafts,
      allowRefresh: allowRefresh,
      isLive: isLive,
      buildContent: (context, route) =>
          vyuh.content.buildContent(context, route),
    );
  }
}
