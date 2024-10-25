import 'package:feature_tmdb/content/search_section.dart';
import 'package:feature_tmdb/ui/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class TmdbSearchStore<T> {
  final client = vyuh.di.get<TMDBClient>();
  final bool isLoading = false;
  List<ChipItem> chips = [];
  ListResponse<T>? data;

  final errorMessage = Observable<String?>(null);
  final selectedChip = Observable<int>(0);
  late ObservableFuture<ListResponse<T>?> fetchFutureData =
      ObservableFuture.value(null);
  final state = Observable(FutureStatus.fulfilled);

  final ScrollController scrollController = ScrollController();

  @action
  Future<void> searchMedia({
    required String query,
    required List<SearchType> searchTypes,
  }) async {
    runInAction(() => errorMessage.value = null);
    if (query.isEmpty) {
      runInAction(() => state.value = FutureStatus.fulfilled);
      chips = searchTypes
          .map((type) => ChipItem(label: type.title, searchType: type))
          .toList();
      return;
    }
    try {
      final future = _fetchDataFromApi(query: query);
      fetchFutureData = ObservableFuture(future);

      data = await fetchFutureData;
      // On successful fetch, update the data and set the state to loaded
      runInAction(() {
        state.value =
            data != null ? FutureStatus.fulfilled : FutureStatus.rejected;
      });
    } catch (error) {
      // If an error occurs, set the state to error and store the error message
      runInAction(() {
        state.value = FutureStatus.rejected;
        errorMessage.value = error.toString();
      });
    }
  }

  void onSearchItemSelection(int index) {
    runInAction(() => selectedChip.value = index);
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<ListResponse<T>?> _fetchDataFromApi({
    required String query,
  }) async {
    runInAction(() => state.value = FutureStatus.pending);
    for (final chip in chips) {
      data = await chip.getItems(query) as ListResponse<T>;
    }
    return data;
  }
}
