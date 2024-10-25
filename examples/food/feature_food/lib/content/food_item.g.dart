// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodMenuItem _$FoodMenuItemFromJson(Map<String, dynamic> json) => FoodMenuItem(
      title: json['title'] as String,
      description: PortableTextContent.fromJson(
          json['description'] as Map<String, dynamic>),
      image: json['image'] == null
          ? null
          : ImageReference.fromJson(json['image'] as Map<String, dynamic>),
      calories: (json['calories'] as num).toDouble(),
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      nutrition: (json['nutrition'] as List<dynamic>?)
              ?.map((e) => NutritionFact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      relatedItems: (json['relatedItems'] as List<dynamic>?)
              ?.map((e) => RelatedFoodItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      layout: typeFromFirstOfListJson(json['layout']),
    );

Ingredient _$IngredientFromJson(Map<String, dynamic> json) => Ingredient(
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] == null
          ? null
          : ImageReference.fromJson(json['image'] as Map<String, dynamic>),
    );

RelatedFoodItem _$RelatedFoodItemFromJson(Map<String, dynamic> json) =>
    RelatedFoodItem(
      name: json['name'] as String,
      calories: (json['calories'] as num).toDouble(),
      image: json['image'] == null
          ? null
          : ImageReference.fromJson(json['image'] as Map<String, dynamic>),
    );

NutritionFact _$NutritionFactFromJson(Map<String, dynamic> json) =>
    NutritionFact(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: $enumDecode(_$NutritionUnitEnumMap, json['unit']),
      dailyValue: (json['dailyValue'] as num?)?.toDouble(),
      includeInSummary: json['includeInSummary'] as bool? ?? false,
    );

const _$NutritionUnitEnumMap = {
  NutritionUnit.grams: 'g',
  NutritionUnit.milligrams: 'mg',
  NutritionUnit.micrograms: 'mcg',
  NutritionUnit.calories: 'cal',
  NutritionUnit.kilocalories: 'kcal',
  NutritionUnit.ounces: 'oz',
  NutritionUnit.fluidOunces: 'fl oz',
  NutritionUnit.milliliters: 'ml',
  NutritionUnit.liters: 'l',
  NutritionUnit.pounds: 'lb',
  NutritionUnit.kilograms: 'kg',
};
