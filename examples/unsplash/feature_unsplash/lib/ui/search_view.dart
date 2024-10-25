import 'package:feature_unsplash/ui/collection_view.dart';
import 'package:feature_unsplash/ui/photo_card.dart';
import 'package:feature_unsplash/unsplash_store.dart';
import 'package:flutter/material.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:vyuh_core/vyuh_core.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  Future<List<Photo>> _resultsFuture = Future.value([]);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SearchBox(
        onResults: (results) => setState(() {
          _resultsFuture = results;
        }),
      ),
      Expanded(
        child: CollectionView<Photo>(
            columns: 2,
            future: () => _resultsFuture,
            itemBuilder: (photo) => PhotoCard(
                  photo: photo,
                  showStats: true,
                  onTap: () =>
                      vyuh.router.push('/unsplash/home/photos/${photo.id}'),
                )),
      ),
    ]);
  }
}

class SearchBox extends StatefulWidget {
  final Function(Future<List<Photo>>) onResults;
  const SearchBox({super.key, required this.onResults});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchController = TextEditingController();

  void _searchPhotos() {
    final store = vyuh.di.get<UnsplashStore>();
    final future = store.searchPhotos(query: _searchController.text);

    widget.onResults(future);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        onSubmitted: (_) => _searchPhotos(),
        textInputAction: TextInputAction.search,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: 'Search Unsplash',
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.search,
            ),
            onPressed: _searchPhotos,
          ),
        ),
      ),
    );
  }
}
