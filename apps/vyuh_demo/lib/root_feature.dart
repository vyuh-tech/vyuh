import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

final feature = FeatureDescriptor(
  name: 'root',
  title: 'Vyuh Root Feature',
  description: 'The root feature for the Vyuh Demo app',
  events: [
    EventHandler<SystemReadyEvent>((_) {
      // Runs once the whole app is ready. The platform subscribes this
      // handler and removes it on restart, so there is nothing to clean up.
      //
      // For example, to switch the default Card layout to your own design
      // system:
      //
      // vyuh.content.setDefaultLayout(
      //   schemaType: Card.schemaName,
      //   layout: ButtonCardLayout(),
      //   fromJson: ButtonCardLayout.fromJson,
      // );
    }),
  ],
  routes: () => [
    GoRoute(path: '/chakra', pageBuilder: defaultRoutePageBuilder),
  ],
);
