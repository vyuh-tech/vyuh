import 'package:chakra_shared/ui/detail_builder.dart';
import 'package:design_system/design_system.dart' hide BorderRadius;
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/formatters.dart';
import 'package:feature_tmdb/ui/sections/preview_list.dart';
import 'package:feature_tmdb/ui/sections/statistics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

class PersonHeroView extends StatelessWidget {
  const PersonHeroView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final personId = GoRouterState.of(context).personId();
    final store = vyuh.di.get<TMDBStore>();

    if (personId == null) {
      return empty;
    }

    return DetailBuilder<Person>(
      futureBuilder: () {
        store.selectPerson(personId);
        return store.getFuture('$personId.person');
      },
      builder: (context, data) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

        return Padding(
          padding: EdgeInsets.only(
            left: theme.spacing.s32,
            top: theme.spacing.s16,
            right: theme.spacing.s32,
          ),
          child: Column(
            children: [
              SizedBox(
                width: theme.sizing.width88(width),
                height: theme.sizing.width43(height),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.zero,
                  child: ContentImage(
                    url: data.profileImage,
                    width: theme.sizing
                        .widthFull(MediaQuery.of(context).size.width),
                    height: theme.sizing
                        .widthFull(MediaQuery.of(context).size.height),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Gap.h20,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  data.name,
                  style: theme.tmdbTheme.displayMedium,
                ),
              ),
              Gap.h20,
            ],
          ),
        );
      },
    );
  }
}

class PersonStatisticsView extends StatelessWidget {
  const PersonStatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final personId = GoRouterState.of(context).personId();
    final store = vyuh.di.get<TMDBStore>();

    if (personId == null) {
      return empty;
    }

    return DetailBuilder<Person>(
      futureBuilder: () {
        store.selectPerson(personId);
        return store.getFuture('$personId.person');
      },
      builder: (context, data) {
        return Padding(
          padding: EdgeInsets.only(
            left: theme.spacing.s32,
            right: theme.spacing.s32,
            top: theme.spacing.s16,
            bottom: theme.spacing.s16,
          ),
          child: Container(
            padding: EdgeInsets.all(theme.spacing.s16),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.start,
              alignment: WrapAlignment.start,
              runSpacing: 10,
              children: [
                Wrap(
                  spacing: theme.spacing.s64,
                  children: [
                    Statistic(
                      title: 'Known For',
                      value: data.knownFor.safeValue,
                      textColor: theme.colorScheme.shadow,
                    ),
                    Statistic(
                      title: 'Gender',
                      value: data.gender == 1 ? 'Female' : 'Male',
                      textColor: theme.colorScheme.shadow,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Statistic(
                      title: 'Birthdate',
                      value: data.birthday.formattedNamedMonth,
                      textColor: theme.colorScheme.shadow,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Statistic(
                        title: 'Place of Birth',
                        value: data.placeOfBirth.safeValue,
                        textColor: theme.colorScheme.shadow,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PersonBiography extends StatelessWidget {
  const PersonBiography({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final personId = GoRouterState.of(context).personId();
    final store = vyuh.di.get<TMDBStore>();

    if (personId == null) {
      return empty;
    }

    return DetailBuilder<Person>(
      futureBuilder: () {
        store.selectPerson(personId);
        return store.getFuture('$personId.person');
      },
      builder: (context, data) {
        final Person person = data;

        if (person.biography == null || person.biography!.isEmpty) {
          return empty;
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.s32,
            vertical: theme.spacing.s16,
          ),
          child: ReadMoreText(
            person.biography ?? "",
            trimLines: 4,
            trimExpandedText: 'Read Less',
            trimCollapsedText: 'Read More',
            moreStyle: theme.tmdbTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.shadow,
            ),
            lessStyle: theme.tmdbTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.shadow,
            ),
            delimiter: "...",
            preDataTextStyle: theme.tmdbTheme.bodyMedium,
            postDataTextStyle: theme.tmdbTheme.bodyMedium,
            style: theme.tmdbTheme.bodyMedium,
            delimiterStyle: theme.tmdbTheme.bodyMedium!.copyWith(),
          ),
        );
      },
    );
  }
}

class PersonMovieCredits extends StatelessWidget {
  const PersonMovieCredits({super.key});

  @override
  Widget build(BuildContext context) {
    final personId = GoRouterState.of(context).personId();
    final store = vyuh.di.get<TMDBStore>();

    if (personId == null) {
      return empty;
    }

    return FeaturedPreviewListSection(
      id: personId,
      futureBuilder: () {
        store.selectPerson(personId);
        return store.getFuture('$personId.person.credits.movie');
      },
      mode: BrowseMode.movies,
      cacheKey: (personId) => '$personId.person.credits.movie',
      title: "Movies",
    );
  }
}

class PersonTvSeriesCredits extends StatelessWidget {
  const PersonTvSeriesCredits({super.key});

  @override
  Widget build(BuildContext context) {
    final personId = GoRouterState.of(context).personId();
    final store = vyuh.di.get<TMDBStore>();
    final theme = Theme.of(context);

    if (personId == null) {
      return empty;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.spacing.s24),
      child: FeaturedPreviewListSection(
        id: personId,
        futureBuilder: () {
          store.selectPerson(personId);
          return store.getFuture('$personId.person.credits.tv');
        },
        mode: BrowseMode.series,
        cacheKey: (personId) => '$personId.person.credits.tv',
        title: "Series",
      ),
    );
  }
}
