import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

feature({required String initialPath}) => FeatureDescriptor(
      name: 'sanity_integration',
      title: 'Sanity Integration',
      description:
          'Shows various features of the CMS Integration, using Sanity.io.',
      icon: Icons.data_object_rounded,
      routes: () async {
        return [
          GoRoute(
              path: '/cms',
              pageBuilder: (context, state) {
                return MaterialPage(
                  child: vyuh.content
                      .buildRoute(context, url: Uri.parse(initialPath)),
                );
              }),
        ];
      },
    );
