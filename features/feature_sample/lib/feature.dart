import 'package:feature_sample/build_routes.dart';
import 'package:vyuh_core/vyuh_core.dart';

final feature = FeatureDescriptor(
  name: 'sample',
  title: 'Sample feature',
  description: 'A sample feature to demo the various capabilities',
  routes: () async {
    return buildRoutes();
  },
  init: () async {
    vyuh.di.register<ThemeService>(ThemeService());
  },
);
