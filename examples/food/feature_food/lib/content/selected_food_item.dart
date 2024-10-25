import 'package:feature_food/api.dart';
import 'package:feature_food/content/food_item.dart';
import 'package:feature_food/content/food_item_default_layout.dart';
import 'package:feature_food/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as go;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'selected_food_item.g.dart';

@JsonSerializable()
final class SelectedFoodItem extends ContentItem {
  static const schemaName = 'food.item.selected';

  static final typeDescriptor = TypeDescriptor(
    fromJson: SelectedFoodItem.fromJson,
    schemaType: schemaName,
    title: 'Selected Food Menu Item',
  );

  SelectedFoodItem({
    super.layout,
  }) : super(schemaType: schemaName);

  factory SelectedFoodItem.fromJson(Map<String, dynamic> json) =>
      _$SelectedFoodItemFromJson(json);
}

final class SelectedFoodMenuItemContentBuilder
    extends ContentBuilder<SelectedFoodItem> {
  SelectedFoodMenuItemContentBuilder()
      : super(
          content: SelectedFoodItem.typeDescriptor,
          defaultLayout: DefaultFoodMenuItemLayout(),
          defaultLayoutDescriptor: DefaultFoodMenuItemLayout.typeDescriptor,
        );
}

@JsonSerializable()
final class DefaultFoodMenuItemLayout
    extends LayoutConfiguration<SelectedFoodItem> {
  static const schemaName = '${SelectedFoodItem.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    fromJson: DefaultFoodMenuItemLayout.fromJson,
    schemaType: schemaName,
    title: 'Default Food Menu Item Layout',
  );

  DefaultFoodMenuItemLayout() : super(schemaType: schemaName);

  factory DefaultFoodMenuItemLayout.fromJson(Map<String, dynamic> json) =>
      _$DefaultFoodMenuItemLayoutFromJson(json);

  @override
  Widget build(BuildContext context, SelectedFoodItem content) {
    final id = go.GoRouterState.of(context).itemId();

    if (id == null) {
      return vyuh.widgetBuilder.errorView(
        context,
        title: 'Failed to load Menu Item',
        subtitle: 'Menu Item ref: $id',
      );
    }

    return FutureBuilder(
      future: vyuh.di.get<FoodApiClient>().fetchMenuItem(id),
      builder: (BuildContext context, AsyncSnapshot<FoodMenuItem?> snapshot) {
        if (snapshot.hasError) {
          return vyuh.widgetBuilder.errorView(
            context,
            error: snapshot.error,
            title: 'Failed to load Menu Item',
            subtitle: 'Menu Item ref: $id',
          );
        } else if (snapshot.hasData) {
          return FoodItem(item: snapshot.data!);
        } else {
          return vyuh.widgetBuilder.contentLoader(context);
        }
      },
    );
  }
}
