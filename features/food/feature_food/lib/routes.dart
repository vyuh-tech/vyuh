import 'package:go_router/go_router.dart' as go;
import 'package:vyuh_core/runtime/cms_route.dart';

List<go.GoRoute> routes() {
  return [
    FoodPath.menu,
    FoodPath.menuItem,
    FoodPath.menuDialog,
  ]
      .map(
        (path) => go.GoRoute(
          path: path,
          pageBuilder: defaultRoutePageBuilder,
        ),
      )
      .toList();
}

extension IdExtraction on go.GoRouterState {
  String? itemId() {
    return uri.queryParameters['id'];
  }
}

abstract class FoodPath {
  static const String menu = '/food/menu';
  static const String menuItem = '/food/menu/item';
  static const String menuDialog = '/food/menu/dialog';
}
