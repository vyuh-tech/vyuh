import 'package:design_system/utils/extensions.dart';
import 'package:feature_food/content/food_item.dart';
import 'package:flutter/material.dart' as f;
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class FoodItem extends StatelessWidget {
  final FoodMenuItem item;

  const FoodItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.onPrimary,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (item.image != null) ContentImage(ref: item.image),
            Padding(
              padding: EdgeInsets.all(theme.spacing.s8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FoodItemHero(item: item),
                  RelatedProducts(relatedItems: item.relatedItems),
                  FoodIngredients(ingredients: item.ingredients),
                  FoodAllergenDescription(ingredients: item.ingredients),
                  NutritionalInformation(nutrition: item.nutrition),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class FoodItemHero extends StatelessWidget {
  final FoodMenuItem item;

  const FoodItemHero({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.title, style: theme.textTheme.headlineMedium),
        Text('${item.calories.toInt()} calories'),
        Padding(
          padding: EdgeInsets.symmetric(vertical: theme.spacing.s20),
          child: vyuh.content.buildContent(context, item.description),
        ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.spacing.s20),
      child: Container(
        padding: EdgeInsets.all(theme.spacing.s8),
        decoration: BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: BorderRadius.circular(theme.borderRadius.small),
        ),
        child: Text(title, style: theme.textTheme.titleLarge),
      ),
    );
  }
}

final class FoodIngredients extends StatelessWidget {
  final List<Ingredient> ingredients;

  const FoodIngredients({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Ingredients'),
        SizedBox(
          height: theme.sizing.s50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              var ingredient = ingredients[index];
              return ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: theme.sizing.s32),
                child: Column(
                  children: [
                    if (ingredient.image != null)
                      ContentImage(
                        ref: ingredient.image,
                        width: theme.sizing.s32,
                        height: theme.sizing.s32,
                        fit: BoxFit.contain,
                      ),
                    Padding(
                      padding: EdgeInsets.all(theme.spacing.s8),
                      child: Text(
                        ingredient.name,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

final class FoodAllergenDescription extends StatelessWidget {
  final List<Ingredient> ingredients;

  const FoodAllergenDescription({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Allergen Information'),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ingredients.length,
          itemBuilder: (context, index) {
            var ingredient = ingredients[index];
            return f.Padding(
              padding: EdgeInsets.only(bottom: theme.spacing.s8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ingredient.name, style: theme.textTheme.titleMedium),
                  Text(ingredient.description),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class RelatedProducts extends StatelessWidget {
  final List<RelatedFoodItem> relatedItems;

  const RelatedProducts({super.key, required this.relatedItems});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Related Products'),
        SizedBox(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: relatedItems.length,
            itemBuilder: (context, index) {
              var relatedItem = relatedItems[index];
              return ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: theme.sizing.s50),
                child: Column(
                  children: [
                    if (relatedItem.image != null)
                      ContentImage(
                        ref: relatedItem.image,
                        width: theme.sizing.s50,
                        height: theme.sizing.s50,
                        fit: BoxFit.contain,
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: theme.spacing.s4),
                      child: Text(
                        relatedItem.name,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    Text(
                      '${relatedItem.calories.toInt()} cal',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(width: theme.sizing.s4),
          ),
        ),
      ],
    );
  }
}

class NutritionalInformation extends StatelessWidget {
  final List<NutritionFact> nutrition;

  const NutritionalInformation({super.key, required this.nutrition});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Nutritional Information'),
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final fact in nutrition.where((x) => x.includeInSummary))
              f.Card(
                elevation: 0,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: theme.spacing.s4),
                      child: Text(
                        fact.name,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Text(
                      '${fact.quantity.toInt()} ${fact.unit.symbol} ${fact.dailyValue == null ? '' : '(${fact.dailyValue!.toInt()}% DV)'}',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: theme.spacing.s20),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final fact
                in nutrition.where((x) => x.includeInSummary == false))
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: theme.spacing.s4),
                    child: Text(
                      '${fact.name}: ',
                      style: theme.textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Text(
                    '${fact.quantity.toInt()} ${fact.unit.symbol} ${fact.dailyValue == null ? '' : '(${fact.dailyValue!.toInt()}% DV)'}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
