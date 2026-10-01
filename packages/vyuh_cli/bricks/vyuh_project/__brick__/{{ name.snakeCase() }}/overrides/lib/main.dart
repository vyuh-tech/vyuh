import 'package:feature_counter/feature_counter.dart' as counter;
import 'package:vyuh_core/vyuh_core.dart' as vc;

void main() async {
  vc.runApp(
    initialLocation: '/counter',
    features: () => [
      counter.feature,
    ],
  );
}
