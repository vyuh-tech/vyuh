import 'package:go_router/go_router.dart' as go;
import 'package:vyuh_core/vyuh_core.dart' hide RouteBase;

Future<List<go.RouteBase>> routes() async {
  return [
    CMSRoute(path: PuzzlesPath.puzzles),
    CMSRoute(
      path: '${PuzzlesPath.puzzlesLevel}/:id',
      cmsPathResolver: puzzlesPathResolver,
    ),
  ];
}

String puzzlesPathResolver(String path) {
  return switch (path) {
    (String x) when x.contains(RegExp(r'/puzzles/level/[a-zA-Z0-9]+')) =>
      '/puzzles/level',
    _ => path
  };
}

extension IdExtraction on go.GoRouterState {
  String? idFromPath() {
    return pathParameters['id'];
  }
}

sealed class PuzzlesPath {
  static const puzzles = '/puzzles';
  static const puzzlesLevel = '/puzzles/level';
}
