import 'package:design_system/design_system.dart' hide BorderRadius;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:feature_tmdb/content/search_section.dart';
import 'package:feature_tmdb/store/tmdb_search_store.dart';
import 'package:feature_tmdb/ui/sections/movie_card.dart';
import 'package:feature_tmdb/ui/sections/people_card.dart';
import 'package:feature_tmdb/ui/sections/series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/runtime/platform/vyuh_platform.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.content});

  final SearchSection content;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final store = vyuh.di.get<TmdbSearchStore>();
    _searchController.addListener(() {
      EasyDebounce.debounce(
        'search-debouncer',
        const Duration(milliseconds: 500),
        () => _searchApi(),
      );
    });

    store.chips = widget.content.searchTypes
        .map((type) => ChipItem(label: type.title, searchType: type))
        .toList();
  }

  void _searchApi() async {
    final query = _searchController.text.trim();
    vyuh.di
        .get<TmdbSearchStore>()
        .searchMedia(query: query, searchTypes: widget.content.searchTypes);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = vyuh.di.get<TmdbSearchStore>();

    return Observer(
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.s32,
                vertical: theme.spacing.s16,
              ),
              child: SearchBar(
                controller: _searchController,
                hintText: 'Search Movies, TV Shows',
                elevation: WidgetStateProperty.all(0),
                leading: const Icon(Icons.search),
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.surfaceContainerHigh,
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(theme.borderRadius.medium),
                  ),
                ),
                trailing: [
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _searchApi();
                      },
                    ),
                ],
              ),
            ),
            if (store.chips[store.selectedChip.value].items != null)
              Padding(
                padding: EdgeInsets.only(bottom: theme.spacing.s8),
                child: AppChipList(
                  items: store.chips,
                  selectedChip: store.selectedChip.value,
                  onItemTap: store.onSearchItemSelection,
                ),
              ),
            Flexible(
              child: SingleChildScrollView(
                controller: store.scrollController,
                child: Column(
                  children: [
                    if (store.state.value == FutureStatus.pending)
                      vyuh.widgetBuilder.contentLoader(context),
                    if (_searchController.text.isNotEmpty)
                      SearchListView(
                        items: store.chips[store.selectedChip.value].items,
                      ),
                  ],
                ),
              ),
            ),
            if (store.chips[store.selectedChip.value].items == null &&
                !store.isLoading)
              if (widget.content.emptyView != null)
                //added flex factor to cover entire screen space left
                Expanded(
                  flex: 50,
                  child: vyuh.content
                      .buildContent(context, widget.content.emptyView!),
                )
              else
                const Expanded(
                  child: Center(
                    child: Text('No Results Found'),
                  ),
                ),
          ],
        );
      },
    );
  }
}

class SearchListView<T> extends StatelessWidget {
  const SearchListView({super.key, required this.items});

  final ListResponse<dynamic>? items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = vyuh.di.get<TmdbSearchStore>();
    if (items == null || items!.results.isEmpty) {
      return Center(
        child: Text(
          'No Results Found',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.outline),
        ),
      );
    }
    if (store.errorMessage.value != null) {
      return vyuh.widgetBuilder.errorView(
        context,
        title: "No search results found",
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: theme.spacing.s8,
        mainAxisSpacing: theme.spacing.s8,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items?.results.length,
      itemBuilder: (context, index) {
        final item = items?.results[index];
        if (item is MovieShortInfo) {
          return MovieCard(
            movie: item,
          );
        } else if (item is SeriesShortInfo) {
          return SeriesCard(
            series: item,
          );
        } else if (item is Person) {
          return PersonView(
            person: item,
            height: theme.sizing.s32,
          );
        }
        return empty;
      },
    );
  }
}

class AppChipList extends StatefulWidget {
  final List<ChipItem> items;
  final Function(int) onItemTap;
  final int selectedChip;
  const AppChipList({
    super.key,
    required this.items,
    required this.onItemTap,
    this.selectedChip = 0,
  });

  @override
  State<AppChipList> createState() => _AppChipListState();
}

class _AppChipListState extends State<AppChipList> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: theme.sizing.s12,
      child: ListView.separated(
        itemCount: widget.items.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          final bgColor = widget.selectedChip == index
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surface;
          final labelColor = widget.selectedChip == index
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onSurface;

          return GestureDetector(
            onTap: () {
              widget.onItemTap(index);
            },
            child: Chip(
              backgroundColor: bgColor,
              label: Row(
                children: [
                  Text(
                    item.label,
                    style: theme.tmdbTheme.bodyMedium?.apply(color: labelColor),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }
}

class ChipItem<T> {
  final String label;
  String? postFix;
  bool selected;
  ListResponse<T>? items;
  final SearchType searchType;

  ChipItem({
    this.items,
    required this.searchType,
    required this.label,
    this.postFix,
    this.selected = false,
  });

  Future<ListResponse<T>> getItems(String query) async {
    final client = vyuh.di.get<TMDBClient>();

    if (searchType == SearchType.movies) {
      items = await client.search.searchMovies(query) as ListResponse<T>;
    } else if (searchType == SearchType.series) {
      items = await client.search.searchSeries(query) as ListResponse<T>;
    } else if (searchType == SearchType.people) {
      items = await client.search.searchPersons(query) as ListResponse<T>;
    } else if (searchType == SearchType.all) {
      items = await client.search.searchAll(query) as ListResponse<T>;
    }
    return items as ListResponse<T>;
  }
}
