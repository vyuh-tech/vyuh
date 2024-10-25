import 'package:flutter/material.dart';

final class CollectionView<T> extends StatelessWidget {
  final Future<List<T>> Function() future;
  final Widget Function(T) itemBuilder;
  final int columns;

  const CollectionView({
    super.key,
    required this.future,
    required this.itemBuilder,
    this.columns = 1,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final items = snapshot.data as List<T>;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 4 / 3,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => itemBuilder(items[index]),
          );
        });
  }
}
