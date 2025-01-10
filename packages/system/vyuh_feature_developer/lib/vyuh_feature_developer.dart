library;

import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'routes.dart';

final feature = FeatureDescriptor(
  name: 'developer',
  title: 'Developer Tools',
  description: 'See details of all features packaged in your app.',
  icon: Icons.code_rounded,
  routes: routes,
);
