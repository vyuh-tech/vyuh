import 'package:design_system/design_system.dart';
import 'package:feature_conference/feature_conference.dart' as conference;
import 'package:feature_counter/feature_counter.dart' as counter;
import 'package:feature_food/feature_food.dart' as food;
import 'package:feature_misc/feature_misc.dart' as misc;
import 'package:feature_puzzles/feature_puzzles.dart' as puzzles;
import 'package:feature_tmdb/feature_tmdb.dart' as tmdb;
import 'package:feature_unsplash/feature_unsplash.dart' as unsplash;
import 'package:feature_wonderous/feature_wonderous.dart' as wonderous;
import 'package:flutter/widgets.dart';
import 'package:vyuh_feature_auth/vyuh_feature_auth.dart' as auth;
import 'package:vyuh_feature_onboarding/vyuh_feature_onboarding.dart'
    as onboarding;
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;
import 'package:vyuh_widgetbook/vyuh_widgetbook.dart';

void main() {
  // Do this because the DesignSystem loads google_fonts
  WidgetsFlutterBinding.ensureInitialized();

  runWidgetBook(
    features: () => [
      system.feature,
      counter.feature,
      tmdb.feature,
      food.feature,
      wonderous.feature,
      puzzles.feature,
      misc.feature,
      unsplash.feature,
      onboarding.feature,
      auth.feature(),
      conference.feature,
    ],
    lightTheme: DesignSystem.lightTheme,
    darkTheme: DesignSystem.darkTheme,
  );
}
