import 'package:feature_unsplash/ui/collection_view.dart';
import 'package:feature_unsplash/ui/photo_card.dart';
import 'package:feature_unsplash/unsplash_store.dart';
import 'package:flutter/material.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:vyuh_core/vyuh_core.dart';

class UnsplashHome extends StatefulWidget {
  const UnsplashHome({super.key});

  @override
  State<UnsplashHome> createState() => _UnsplashHomeState();
}

class _UnsplashHomeState extends State<UnsplashHome>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        TabController(length: UnsplashSections.values.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _controller,
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              tabs: UnsplashSections.values
                  .map((section) => Tab(text: section.title))
                  .toList(),
            ),
            Expanded(
              child: TabBarView(
                  controller: _controller,
                  children: UnsplashSections.values
                      .map((section) => section.buildWidget(context))
                      .toList(growable: false)),
            ),
          ],
        ),
      ),
    );
  }
}

enum UnsplashSections {
  latest,
  featured,
  collections,
  topics;

  String get title => name.characters.first.toUpperCase() + name.substring(1);

  Widget buildWidget(BuildContext context) {
    final store = vyuh.di.get<UnsplashStore>();

    switch (this) {
      case UnsplashSections.latest:
        return CollectionView<Photo>(
          future: () =>
              store.fetchPhotos(count: 10, orderBy: PhotoOrder.latest),
          itemBuilder: (photo) => PhotoCard(
            photo: photo,
            showStats: true,
            onTap: () => vyuh.router.push('/unsplash/home/photos/${photo.id}'),
          ),
        );
      case UnsplashSections.featured:
        return CollectionView<Photo>(
          future: () => store.fetchFeaturedPhotos(count: 10),
          itemBuilder: (photo) => PhotoCard(
            photo: photo,
            showStats: true,
            onTap: () => vyuh.router.push('/unsplash/home/photos/${photo.id}'),
          ),
        );
      case UnsplashSections.collections:
        return CollectionView<Collection>(
          future: () => store.fetchCollections(count: 10),
          itemBuilder: (collection) => collection.coverPhoto != null
              ? PhotoCard(
                  title: '${collection.title}  (${collection.totalPhotos})',
                  photo: collection.coverPhoto!,
                  onTap: () => vyuh.router
                      .push('/unsplash/home/collections/${collection.id}'),
                )
              : const Icon(Icons.question_mark),
        );
      case UnsplashSections.topics:
        return CollectionView<Topic>(
          future: () => store.fetchTopics(count: 10),
          itemBuilder: (topic) => PhotoCard(
            title: topic.title,
            photo: topic.coverPhoto,
            onTap: () => vyuh.router.push('/unsplash/home/topics/${topic.id}'),
          ),
        );
    }
  }
}
