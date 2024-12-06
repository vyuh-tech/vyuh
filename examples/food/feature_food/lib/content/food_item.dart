import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'food_item.g.dart';

@JsonSerializable()
final class FoodMenuItem extends ContentItem {
  final String title;
  final PortableTextContent description;
  final ImageReference? image;
  final double calories;

  final List<Ingredient> ingredients;
  final List<NutritionFact> nutrition;
  final List<RelatedFoodItem> relatedItems;

  FoodMenuItem({
    required this.title,
    required this.description,
    this.image,
    required this.calories,
    this.ingredients = const [],
    this.nutrition = const [],
    this.relatedItems = const [],
    super.layout,
    super.modifiers,
  }) : super(schemaType: 'food.item');

  factory FoodMenuItem.fromJson(Map<String, dynamic> json) =>
      _$FoodMenuItemFromJson(json);
}

@JsonSerializable()
final class Ingredient {
  final String name;
  final String description;
  final ImageReference? image;

  Ingredient({
    required this.name,
    required this.description,
    required this.image,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}

@JsonSerializable()
final class RelatedFoodItem {
  final String name;
  final double calories;
  final ImageReference? image;

  RelatedFoodItem({
    required this.name,
    required this.calories,
    required this.image,
  });

  factory RelatedFoodItem.fromJson(Map<String, dynamic> json) =>
      _$RelatedFoodItemFromJson(json);
}

@JsonSerializable()
final class NutritionFact {
  final String name;
  final double quantity;
  final NutritionUnit unit;
  final double? dailyValue;
  final bool includeInSummary;

  NutritionFact({
    required this.name,
    required this.quantity,
    required this.unit,
    this.dailyValue,
    this.includeInSummary = false,
  });

  factory NutritionFact.fromJson(Map<String, dynamic> json) =>
      _$NutritionFactFromJson(json);
}

enum NutritionUnit {
  @JsonValue('g')
  grams,
  @JsonValue('mg')
  milligrams,
  @JsonValue('mcg')
  micrograms,
  @JsonValue('cal')
  calories,
  @JsonValue('kcal')
  kilocalories,
  @JsonValue('oz')
  ounces,
  @JsonValue('fl oz')
  fluidOunces,
  @JsonValue('ml')
  milliliters,
  @JsonValue('l')
  liters,
  @JsonValue('lb')
  pounds,
  @JsonValue('kg')
  kilograms;

  String get symbol {
    switch (this) {
      case NutritionUnit.grams:
        return 'g';
      case NutritionUnit.milligrams:
        return 'mg';
      case NutritionUnit.micrograms:
        return 'mcg';
      case NutritionUnit.calories:
        return 'cal';
      case NutritionUnit.kilocalories:
        return 'kcal';
      case NutritionUnit.ounces:
        return 'oz';
      case NutritionUnit.fluidOunces:
        return 'fl oz';
      case NutritionUnit.milliliters:
        return 'ml';
      case NutritionUnit.liters:
        return 'l';
      case NutritionUnit.pounds:
        return 'lb';
      case NutritionUnit.kilograms:
        return 'kg';
    }
  }
}
