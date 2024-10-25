import 'package:feature_food/action/select_menu_item.dart';
import 'package:feature_food/api.dart';
import 'package:feature_food/content/selected_food_item.dart';
import 'package:feature_food/routes.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

final feature = FeatureDescriptor(
  name: 'food',
  title: 'Food',
  description: 'Food feature to showcase food menu items.',
  icon: Icons.fastfood,
  init: () async {
    vyuh.di.register(FoodApiClient());
  },
  routes: () => routes(),
  extensions: [
    ContentExtensionDescriptor(
      contentBuilders: [
        SelectedFoodMenuItemContentBuilder(),
      ],
      actions: [
        SelectMenuItem.typeDescriptor,
      ],
    ),
  ],
);
