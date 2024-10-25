import 'package:feature_unsplash/ui/collection_view.dart';
import 'package:feature_unsplash/ui/photo_card.dart';
import 'package:feature_unsplash/unsplash_store.dart';
import 'package:flutter/material.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class TopicDetailView extends StatelessWidget {
  final String id;
  const TopicDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final store = vyuh.di.get<UnsplashStore>();

    return Scaffold(
      appBar: AppBar(title: Text(id)),
      body: CollectionView<Photo>(
        future: () => store.fetchTopic(id: id),
        itemBuilder: (photo) => PhotoCard(
          photo: photo,
          showStats: true,
          onTap: () => vyuh.router.push('/unsplash/home/photos/${photo.id}'),
        ),
      ),
    );
  }
}
