import 'package:feature_food/content/food_item.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class FoodApiClient {
  Future<FoodMenuItem?> fetchMenuItem(String id) {
    return vyuh.content.provider.fetchSingle(
      '*[_type == "food.item" && _id == "$id"][0]',
      fromJson: FoodMenuItem.fromJson,
    );
  }
}
