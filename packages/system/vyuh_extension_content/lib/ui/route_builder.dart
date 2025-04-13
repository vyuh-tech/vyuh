import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'route_future_builder.dart';
import 'route_stream_builder.dart';
import 'scoped_di_widget.dart';

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
    final label = [
      url == null ? null : 'Url: $url',
      routeId == null ? null : 'RouteId: $routeId',
      'Route',
    ].firstWhere((x) => x != null);

    final provider = vyuh.content.provider;

    return ScopedDIWidget(
      debugLabel: 'Scoped DI for $label',
      child: isLive && provider.supportsLive
          ? _buildLiveRoute(context, url: url, routeId: routeId)
          : _buildStaticRoute(context, url: url, routeId: routeId),
    );
  }

  /// Builds a route with live updates using RouteStreamBuilder
  Widget _buildLiveRoute(BuildContext context, {Uri? url, String? routeId}) {
    return RouteStreamBuilder(
      url: url,
      routeId: routeId,
      includeDrafts: kDebugMode,
      allowRefresh: allowRefresh,
      fetchRoute: (context, {path, routeId, includeDrafts = false}) {
        // Get the base stream from the provider
        final stream = vyuh.content.provider.live.fetchRoute(
          path: path,
          routeId: routeId,
          includeDrafts: includeDrafts,
        );

        // Transform the stream to handle DI scope resets
        return stream.asyncMap(
            (route) => context.mounted ? _initRoute(context, route) : null);
      },
      buildContent: vyuh.content.buildContent,
    );
  }

  /// Builds a route with one-time loading using RouteFutureBuilder
  Widget _buildStaticRoute(BuildContext context, {Uri? url, String? routeId}) {
    return RouteFutureBuilder(
      url: url,
      routeId: routeId,
      allowRefresh: allowRefresh,
      fetchRoute: (context, {path, routeId}) => vyuh.content.provider
          .fetchRoute(path: path, routeId: routeId)
          .then((route) => context.mounted ? _initRoute(context, route) : null),
      buildContent: vyuh.content.buildContent,
    );
  }

  /// Common method to initialize a route with proper DI scope handling
  /// This ensures consistent behavior between live and static routes
  Future<RouteBase?> _initRoute(BuildContext context, RouteBase? route) async {
    if (route == null) {
      return null;
    }

    // Reset DI scope when a new route is fetched
    await context.di.reset();

    if (!context.mounted) {
      return null;
    }

    // Now initialize the new route with the clean DI scope
    final finalRoute = await route.init(context);
    return finalRoute;
  }
}
