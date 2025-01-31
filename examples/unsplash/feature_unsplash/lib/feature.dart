import 'package:feature_unsplash/routes.dart';
import 'package:feature_unsplash/unsplash_store.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

final feature = FeatureDescriptor(
  name: 'unsplash',
  title: 'Unsplash',
  description: 'View photos, collections and users on Unsplash',
  icon: Icons.photo_camera,
  init: (platform) async {
    final accessKey = platform.env.get('UNSPLASH_ACCESS_KEY');
    final secretKey = platform.env.get('UNSPLASH_SECRET_KEY');

    platform.di.register(
      UnsplashStore(
        accessKey: accessKey,
        secretKey: secretKey,
      ),
    );
  },
  routes: routes,
);
