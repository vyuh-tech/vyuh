import 'package:design_system/design_system.dart' hide BorderRadius;
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/common_widgets/box_widget.dart';
import 'package:flutter/material.dart' hide Action, Route;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'tmdb_media_toggle_layout.g.dart';

@JsonSerializable()
final class TmdbMediaToggleLayout extends LayoutConfiguration<Route> {
  static const schemaName = 'tmdb.route.layout.mediaToggle';
  final String? title;
  final String? subtitle;
  final String movieRoute;
  final String seriesRoute;

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: TmdbMediaToggleLayout.fromJson,
    title: 'Tmdb Media Toggle Layout',
  );
  TmdbMediaToggleLayout({
    this.title,
    this.subtitle,
    required this.movieRoute,
    required this.seriesRoute,
  }) : super(schemaType: schemaName);

  factory TmdbMediaToggleLayout.fromJson(Map<String, dynamic> json) =>
      _$TmdbMediaToggleLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Route content) {
    return TmdbMediaToggleLayoutView(
      layout: this,
      content: content,
    );
  }
}

final class TmdbMediaToggleLayoutView extends StatefulWidget {
  final TmdbMediaToggleLayout layout;
  final Route content;
  const TmdbMediaToggleLayoutView({
    super.key,
    required this.layout,
    required this.content,
  });

  @override
  State<TmdbMediaToggleLayoutView> createState() =>
      _TmdbMediaToggleLayoutViewState();
}

class _TmdbMediaToggleLayoutViewState extends State<TmdbMediaToggleLayoutView> {
  @override
  Widget build(BuildContext context) {
    return RouteScaffold(
      content: widget.content,
      appBar: _customAppBar(),
      useSafeArea: true,
      body: Observer(
        builder: (context) {
          final store = vyuh.di.get<TMDBStore>();

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: IndexedStack(
              key: ValueKey(store.isMoviesMode ? 0 : 1),
              index: store.isMoviesMode ? 0 : 1,
              children: [
                vyuh.content.buildRoute(
                  context,
                  url: Uri(path: widget.layout.movieRoute),
                ),
                vyuh.content.buildRoute(
                  context,
                  url: Uri(path: widget.layout.seriesRoute),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _customAppBar() {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.onPrimary,
      leading: widget.layout.subtitle == null
          ? IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                vyuh.router.go('/chakra');
              },
            )
          : null,
      titleSpacing: theme.spacing.s24,
      title: getTitle(),
      centerTitle: false,
      actions: getActions(),
    );
  }

  Widget? getTitle() {
    final theme = Theme.of(context);

    return widget.layout.subtitle != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.layout.title ?? '',
                style: theme.tmdbTheme.displaySmall,
              ),
              Text(
                widget.layout.subtitle ?? '',
                style: theme.tmdbTheme.bodySmall,
              ),
            ],
          )
        : empty;
  }

  List<Widget> getActions() {
    final store = vyuh.di.get<TMDBStore>();
    final theme = Theme.of(context);

    return [
      Padding(
        padding: EdgeInsets.only(
          top: theme.spacing.s8,
          bottom: theme.spacing.s8,
          right: theme.spacing.s16,
        ),
        child: Observer(
          builder: (context) => Row(
            children: [
              BoxWidget(
                isSelected: store.isMoviesMode,
                title: 'Movies',
                icon: Icons.movie_outlined,
              ),
              SizedBox(width: theme.spacing.s8),
              BoxWidget(
                isSelected: !store.isMoviesMode,
                title: 'Series',
                icon: Icons.tv_outlined,
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
