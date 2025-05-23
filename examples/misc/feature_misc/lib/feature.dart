import 'package:feature_misc/action/show_barcode.dart';
import 'package:feature_misc/condition/part_of_day.dart';
import 'package:feature_misc/content/api/dummy_json_api_content.dart';
import 'package:feature_misc/content/card_layout_di_store.dart';
import 'package:feature_misc/content/live_card.dart';
import 'package:feature_misc/content/product/default_layout.dart';
import 'package:feature_misc/content/product/mini_view_layout.dart';
import 'package:feature_misc/content/product/product_card.dart';
import 'package:feature_misc/content/score_card.dart';
import 'package:feature_misc/lifecycle_handlers/di_registration_lifecycle_handler.dart';
import 'package:feature_misc/lifecycle_handlers/simulated_delay_lifecycle_handler.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

final feature = FeatureDescriptor(
  name: 'misc',
  title: 'Misc',
  description:
      'Miscellaneous feature showing all capabilities of the Vyuh Framework.',
  icon: Icons.miscellaneous_services_outlined,
  routes: () async {
    return [
      CMSRoute(
        path: '/misc',
        routes: [
          CMSRoute(path: ':path(.*)'),
        ],
      ),
    ];
  },
  extensions: [
    ContentExtensionDescriptor(
      contents: [
        ProductCardDescriptor(
          layouts: [
            DefaultProductCardLayout.typeDescriptor,
            MiniViewProductCardLayout.typeDescriptor,
          ],
        ),
        APIContentDescriptor(
          configurations: [
            DummyJsonApiConfiguration.typeDescriptor,
          ],
        ),
        RouteDescriptor(
          lifecycleHandlers: [
            SimulatedDelayLifecycleHandler.typeDescriptor,
            DIRegistrationLifecycleHandler.typeDescriptor,
          ],
        ),
        CardDescriptor(
          layouts: [
            DIStoreCardLayout.typeDescriptor,
          ],
        )
      ],
      contentBuilders: [
        ProductCard.contentBuilder,
        LiveCard.contentBuilder,
        Document.contentBuilder,
        ScoreCard.contentBuilder,
      ],
      conditions: [
        PartOfDayCondition.typeDescriptor,
      ],
      actions: [
        ShowBarcodeAction.typeDescriptor,
      ],
    ),
  ],
);
