import 'package:design_system/design_system.dart' hide BorderRadius;
import 'package:flutter/material.dart' hide Action, Route;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'tmdb_list_layout.g.dart';

@JsonSerializable()
final class TmdbListLayout extends LayoutConfiguration<Route> {
  static const schemaName = 'tmdb.route.layout.list';
  final String? title;
  final String? subtitle;
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: TmdbListLayout.fromJson,
    title: 'Tmdb List Layout',
  );

  TmdbListLayout({
    required this.title,
    required this.subtitle,
  }) : super(schemaType: schemaName);

  factory TmdbListLayout.fromJson(Map<String, dynamic> json) =>
      _$TmdbListLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Route content) {
    return TmdbListLayoutLayoutView(
      layout: this,
      content: content,
    );
  }
}

final class TmdbListLayoutLayoutView extends StatelessWidget {
  final TmdbListLayout layout;
  final Route content;
  const TmdbListLayoutLayoutView({
    super.key,
    required this.layout,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return RouteScaffold(
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          layout.title ?? '',
          style: theme.tmdbTheme.displaySmall,
        ),
        if (layout.subtitle != null)
          Text(
            layout.subtitle ?? '',
            style: theme.tmdbTheme.bodySmall,
          ),
      ],
    );
  }
}
