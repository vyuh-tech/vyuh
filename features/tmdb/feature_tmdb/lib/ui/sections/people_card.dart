import 'dart:math';

import 'package:chakra_shared/ui/detail_builder.dart';
import 'package:design_system/design_system.dart' as ds;
import 'package:feature_tmdb/content/enums/config_enum.dart';
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/formatters.dart';
import 'package:feature_tmdb/ui/section_title.dart';
import 'package:feature_tmdb/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_client/model/person.dart';
import 'package:vyuh_core/runtime/platform/vyuh_platform.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;

class PeopleSectionView extends StatelessWidget {
  final BrowseMode mode;
  final ListRepresentation representation;
  final String title;
  final bool isCast;

  const PeopleSectionView({
    this.title = 'Top Cast',
    super.key,
    required this.mode,
    this.representation = ListRepresentation.short,
    this.isCast = true,
  });

  factory PeopleSectionView.crew({
    required BrowseMode mode,
    ListRepresentation representation = ListRepresentation.short,
    required bool isCast,
  }) =>
      PeopleSectionView(
        mode: mode,
        representation: representation,
        title: 'Top Crew',
        isCast: isCast,
      );

  factory PeopleSectionView.large({
    required BrowseMode mode,
    ListRepresentation representation = ListRepresentation.long,
    required bool isCast,
  }) =>
      PeopleSectionView(
        mode: mode,
        representation: representation,
        isCast: isCast,
      );

  @override
  Widget build(BuildContext context) {
    final cacheSuffix = mode == BrowseMode.series ? 'series' : 'movie';
    final store = vyuh.di.get<TMDBStore>();

    int? idx = mode.selectedId(context);
    return DetailBuilder<Credits>(
      futureBuilder: () {
        return store.getFuture('$idx.$cacheSuffix.credits');
      },
      builder: (context, data) {
        final credits = data;
        return representation == ListRepresentation.short
            ? PersonListView(
                title: title,
                people: isCast ? credits.cast : credits.crew,
                onViewAllTap: () {
                  if (isCast) {
                    mode == BrowseMode.movies
                        ? vyuh.router.push(TmdbPath.movieCastList(idx ?? 0))
                        : vyuh.router.push(TmdbPath.seriesCastList(idx ?? 0));
                  } else {
                    mode == BrowseMode.movies
                        ? vyuh.router.push(TmdbPath.movieCrewList(idx ?? 0))
                        : vyuh.router.push(TmdbPath.seriesCrewList(idx ?? 0));
                  }
                },
              )
            : PersonListViewLargeCard(
                people: isCast ? credits.cast : credits.crew,
              );
      },
    );
  }
}

class PersonListView extends StatelessWidget {
  final List<BasePerson> people;

  final String title;

  final void Function()? onViewAllTap;

  const PersonListView({
    super.key,
    required this.title,
    required this.people,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (people.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: theme.spacing.s32,
              right: theme.spacing.s16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SectionTitle(title: title),
                if (people.shouldShowViewAll && onViewAllTap != null)
                  TextButton(
                    onPressed: onViewAllTap,
                    child: Row(
                      children: [
                        Text(
                          'See All',
                          style: theme.tmdbTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 24,
                          color: theme.colorScheme.secondary,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: theme.spacing.s32,
              right: theme.spacing.s32,
            ),
            child: SizedBox(
              height: theme.sizing.width20(MediaQuery.sizeOf(context).height),
              child: people.isEmpty
                  ? vf.empty
                  : ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(width: theme.spacing.s8),
                      scrollDirection: Axis.horizontal,
                      itemCount: min(maxCountForViewAll, people.length),
                      itemBuilder: (context, index) => PersonView(
                        person: people[index],
                      ),
                    ),
            ),
          ),
        ],
      );
    } else {
      return vf.empty;
    }
  }
}

class PersonView extends StatelessWidget {
  const PersonView({
    super.key,
    required this.person,
    this.height,
  });

  final BasePerson person;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        vyuh.di.get<TMDBStore>().selectPerson(person.id);
        vyuh.router.push(TmdbPath.personDetails(person.id));
      },
      child: SizedBox(
        width: theme.sizing.s28,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 7,
              child: SizedBox(
                height: height ?? theme.sizing.s28,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: vf.ContentImage(
                    url: person.profileImage,
                    height: theme.sizing
                        .widthFull(MediaQuery.sizeOf(context).height),
                    width: theme.sizing
                        .widthFull(MediaQuery.sizeOf(context).width),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(
                  left: theme.spacing.s8,
                  right: theme.spacing.s8,
                  // bottom: theme.spacing.s4,
                ),
                child: Text(
                  person.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  style: theme.tmdbTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(
                  left: theme.spacing.s8,
                ),
                child: Text(
                  person.knownFor.safeValue,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  style: theme.tmdbTheme.bodySmall
                      ?.apply(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PersonListViewLargeCard extends StatelessWidget {
  final List<BasePerson> people;

  const PersonListViewLargeCard({
    super.key,
    required this.people,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return LimitedBox(
      maxHeight: theme.sizing.width80(size.height),
      child: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          return PersonLargeCard(person: people[index]);
        },
      ),
    );
  }
}

class PersonLargeCard extends StatelessWidget {
  final BasePerson person;
  final bool isCast;

  const PersonLargeCard({
    super.key,
    required this.person,
    this.isCast = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        vyuh.di.get<TMDBStore>().selectPerson(person.id);
        vyuh.router.push(TmdbPath.personDetails(person.id));
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: theme.spacing.s32,
          right: theme.spacing.s32,
          top: theme.spacing.s24,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: theme.sizing.s31,
                  width: theme.sizing.s31,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: vf.ContentImage(
                      url: person.profileImage,
                      width: theme.sizing
                          .widthFull(MediaQuery.sizeOf(context).width),
                      height: theme.sizing
                          .widthFull(MediaQuery.sizeOf(context).height),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: theme.spacing.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(person.name, style: theme.tmdbTheme.headlineSmall),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: theme.spacing.s8),
                          child: Text(
                            person.knownFor.safeValue,
                            style: theme.tmdbTheme.bodySmall,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: theme.spacing.s8),
                          child: Text(
                            'Known for Department: ${person.knownForDepartment}',
                            style: theme.tmdbTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: theme.spacing.s16,
              ),
              child: const Divider(),
            ),
          ],
        ),
      ),
    );
  }
}
