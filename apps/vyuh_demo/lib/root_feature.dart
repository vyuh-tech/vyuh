import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

final feature = FeatureDescriptor(
  name: 'root',
  title: 'Vyuh Root Feature',
  description: 'The root feature for the Vyuh Demo app',
  routes: () => [
    GoRoute(path: '/chakra', pageBuilder: defaultRoutePageBuilder),
  ],
);
