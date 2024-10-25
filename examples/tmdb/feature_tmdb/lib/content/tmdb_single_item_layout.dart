import 'package:design_system/design_system.dart' hide BorderRadius;
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/utils/utils.dart';
import 'package:flutter/material.dart' hide Action, Route;
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/ui/single_item_route_scaffold.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'tmdb_single_item_layout.g.dart';

@JsonSerializable()
final class TmdbSingleItemLayout extends LayoutConfiguration<Route> {
  static const schemaName = 'tmdb.route.layout.single';
  final String? title;
  final String? subtitle;

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: TmdbSingleItemLayout.fromJson,
    title: 'Tmdb Single Item Layout',
  );

  TmdbSingleItemLayout({
    required this.title,
    required this.subtitle,
  }) : super(schemaType: schemaName);

  factory TmdbSingleItemLayout.fromJson(Map<String, dynamic> json) =>
      _$TmdbSingleItemLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Route content) {
    return TmdbSingleItemLayoutView(
      layout: this,
      content: content,
    );
  }
}

final class TmdbSingleItemLayoutView extends StatelessWidget {
  final TmdbSingleItemLayout layout;
  final Route content;
  const TmdbSingleItemLayoutView({
    super.key,
    required this.layout,
    required this.content,
  });

  String _getResourceType(BuildContext context) {
    final genreId = GoRouterState.of(context).genreId();

    if (genreId != null) {
      return TmdbUtils.getGenre(genreId) ?? '';
    }

    final store = vyuh.di.get<TMDBStore>();
    String type = '';
    if (store.isMoviesMode) {
      type = GoRouterState.of(context).movieListType()?.title ?? '-';
    } else {
      type = GoRouterState.of(context).seriesListType()?.title ?? '-';
    }
    return type;
  }

  @override
  Widget build(BuildContext context) {
    return SingleItemRouteScaffold(
      content: content,
      appBar: _customAppBar(context),
      useSafeArea: true,
    );
  }

  AppBar _customAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      centerTitle: false,
      titleSpacing: 10,
      leading: Padding(
        padding: EdgeInsets.only(left: theme.spacing.s8),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            vyuh.router.pop();
          },
        ),
      ),
      title: getTitle(context),
    );
  }

  Widget getTitle(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = _getResourceType(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          layout.title ?? '',
          style: theme.tmdbTheme.displaySmall,
        ),
        if (subtitle.isNotEmpty)
          Text(
            layout.subtitle ?? subtitle,
            style: theme.tmdbTheme.bodySmall,
          ),
      ],
    );
  }
}
