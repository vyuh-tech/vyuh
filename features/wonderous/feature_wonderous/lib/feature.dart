import 'package:feature_wonderous/api/wonder.dart';
import 'package:feature_wonderous/api/wonder_client.dart';
import 'package:feature_wonderous/content/query_configurations.dart';
import 'package:feature_wonderous/content/section.dart';
import 'package:feature_wonderous/content/wonder_list_item.dart';
import 'package:feature_wonderous/routes.dart';
import 'package:feature_wonderous/ui/page_view_layout.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/content/document_view/document.dart';
import 'package:vyuh_feature_system/content/document_view/document_list.dart';
import 'package:vyuh_feature_system/content/document_view/document_section.dart';
import 'package:vyuh_feature_system/content/group/group.dart';

final feature = FeatureDescriptor(
  name: 'wonderous',
  title: 'Wonderous',
  description: 'The Wonderous app as a Vyuh Feature',
  icon: Icons.castle_outlined,
  init: () async {
    final accessKey = vyuh.env.get('UNSPLASH_ACCESS_KEY');
    final secretKey = vyuh.env.get('UNSPLASH_SECRET_KEY');

    vyuh.di.register(
      WonderClient(
        unsplashAccessKey: accessKey,
        unsplashSecretKey: secretKey,
      ),
    );
  },
  routes: routes,
  extensions: [
    ContentExtensionDescriptor(
      contents: [
        DocumentViewDescriptor(
          queries: [
            WonderQueryConfiguration.typeDescriptor,
          ],
          documentTypes: [
            Wonder.typeDescriptor,
          ],
        ),
        DocumentSectionViewDescriptor(
          configurations: [
            WonderSectionConfiguration.typeDescriptor,
          ],
        ),
        DocumentListViewDescriptor(
          documentTypes: [
            WonderMiniInfo.typeDescriptor,
          ],
          queryConfigurations: [
            WonderListQueryConfiguration.typeDescriptor,
          ],
          listItemConfigurations: [
            WonderListItemConfiguration.typeDescriptor,
          ],
        ),
        GroupDescriptor(
          layouts: [
            TypeDescriptor(
              schemaType: 'vyuh.group.layout.pageView',
              fromJson: PageViewLayout.fromJson,
              title: 'Page View Layout',
            ),
          ],
        ),
      ],
    ),
  ],
);
