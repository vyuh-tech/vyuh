import 'package:feature_puzzles/api/model/level.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class PuzzleClient {
  final Map<String, ObservableFuture<Level?>> _levelFutures = {};

  ObservableFuture<Level?> fetchLevel(String id) {
    if (_levelFutures.containsKey(id)) {
      return _levelFutures[id]!;
    }

    final levelFuture = vyuh.content.provider.fetchSingle(
      '*[_type == "puzzles.level" && _id == "$id"][0]',
      fromJson: Level.fromJson,
    );

    _levelFutures[id] = ObservableFuture(levelFuture);

    return _levelFutures[id]!;
  }

  clearCache() {
    _levelFutures.clear();
  }
}
