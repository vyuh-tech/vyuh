import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart' as vyuh;

void main() {
  vyuh.runApp(
    initialLocation: '/',
    features: () => [
      vyuh.FeatureDescriptor(
        name: 'hello',
        title: 'Hello',
        routes: () => [
          GoRoute(
            path: '/',
            builder: (_, _) =>
                const Scaffold(body: Center(child: Text('Hello, Vyuh.'))),
          ),
        ],
      ),
    ],
  );
}
