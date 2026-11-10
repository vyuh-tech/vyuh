import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart';

void main() {
  group('VyuhTheme', () {
    test('copyWith replaces only the given fields', () {
      final base = VyuhTheme.fromSeed(Colors.teal);
      final light = ThemeData(colorSchemeSeed: Colors.red);

      final same = base.copyWith();
      expect(same.light, base.light);
      expect(same.dark, base.dark);
      expect(same.mode, ThemeMode.system);

      final changed = base.copyWith(
        light: light,
        dark: light,
        mode: ThemeMode.dark,
      );
      expect(changed.light, light);
      expect(changed.dark, light);
      expect(changed.mode, ThemeMode.dark);
    });
  });

  group('VyuhThemeExtension', () {
    const red = Color(0xFFFF0000);
    const blue = Color(0xFF0000FF);

    VyuhThemeExtension filled(Color color, double radius) => VyuhThemeExtension(
      appLoaderBackground: color,
      loaderColor: color,
      routeLoaderBackground: color,
      placeholderBackground: color,
      placeholderForeground: color,
      failureBackground: color,
      failureForeground: color,
      debugBackground: color,
      debugForeground: color,
      debugBorder: color,
      radius: radius,
      loaderDelay: Duration(milliseconds: radius.toInt()),
      showPoweredBy: radius > 10,
    );

    test('copyWith keeps unset tokens and replaces given ones', () {
      final base = filled(red, 4);
      expect(base.copyWith().loaderColor, red);
      expect(base.copyWith().radius, 4);

      final next = base.copyWith(
        appLoaderBackground: blue,
        loaderColor: blue,
        routeLoaderBackground: blue,
        placeholderBackground: blue,
        placeholderForeground: blue,
        failureBackground: blue,
        failureForeground: blue,
        debugBackground: blue,
        debugForeground: blue,
        debugBorder: blue,
        radius: 20,
        loaderDelay: Duration.zero,
        showPoweredBy: false,
      );
      expect(next.appLoaderBackground, blue);
      expect(next.loaderColor, blue);
      expect(next.routeLoaderBackground, blue);
      expect(next.placeholderBackground, blue);
      expect(next.placeholderForeground, blue);
      expect(next.failureBackground, blue);
      expect(next.failureForeground, blue);
      expect(next.debugBackground, blue);
      expect(next.debugForeground, blue);
      expect(next.debugBorder, blue);
      expect(next.radius, 20);
      expect(next.loaderDelay, Duration.zero);
      expect(next.showPoweredBy, isFalse);
    });

    test('lerp blends colors and radius, and switches discrete tokens at '
        'the midpoint', () {
      final a = filled(red, 4);
      final b = filled(blue, 20);

      expect(a.lerp(null, 0.5), same(a));

      final early = a.lerp(b, 0.25);
      expect(early.radius, 8);
      expect(early.loaderDelay, a.loaderDelay);
      expect(early.showPoweredBy, isFalse);
      final mid = Color.lerp(red, blue, 0.25);
      for (final color in [
        early.appLoaderBackground,
        early.loaderColor,
        early.routeLoaderBackground,
        early.placeholderBackground,
        early.placeholderForeground,
        early.failureBackground,
        early.failureForeground,
        early.debugBackground,
        early.debugForeground,
        early.debugBorder,
      ]) {
        expect(color, mid);
      }

      final late = a.lerp(b, 0.75);
      expect(late.loaderDelay, b.loaderDelay);
      expect(late.showPoweredBy, isTrue);
      expect(late.radius, 16);
    });

    testWidgets('of() fills the tokens a theme leaves out from its scheme', (
      tester,
    ) async {
      late VyuhThemeExtension tokens;
      late ColorScheme scheme;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorSchemeSeed: Colors.green,
            extensions: const [
              VyuhThemeExtension(loaderColor: red, showPoweredBy: false),
            ],
          ),
          home: Builder(
            builder: (context) {
              tokens = VyuhThemeExtension.of(context);
              scheme = Theme.of(context).colorScheme;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(tokens.loaderColor, red);
      expect(tokens.showPoweredBy, isFalse);
      expect(tokens.appLoaderBackground, scheme.surface);
      expect(tokens.failureBackground, scheme.errorContainer);
      expect(tokens.debugBorder, scheme.error);
      expect(tokens.radius, 12);
      expect(tokens.loaderDelay, const Duration(milliseconds: 200));
    });

    testWidgets('VyuhBranding hides when the theme turns it off', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: const [VyuhThemeExtension(showPoweredBy: false)],
          ),
          home: const VyuhBranding(),
        ),
      );
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.textContaining('Vyuh'), findsNothing);
    });
  });
}
