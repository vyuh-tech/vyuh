import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;

const _style = vc.VyuhThemeExtension(
  failureTitleStyle: TextStyle(color: Color(0xFF112233), fontSize: 30),
  failureMessageStyle: TextStyle(color: Color(0xFF445566)),
  failureIcons: {vc.FailureKind.notFound: Icons.search_off},
  failureIconSize: 64,
  failureMaxWidth: 320,
);

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(extensions: const [_style]),
  home: child,
);

const _notFound = vc.VyuhFailure(
  kind: vc.FailureKind.notFound,
  title: 'Gone',
  message: 'Nothing here.',
);

void main() {
  testWidgets('a failure page uses the theme failure tokens', (tester) async {
    await tester.pumpWidget(
      _app(
        const vc.VyuhFailureScope(
          failure: _notFound,
          child: vc.FailurePage(title: 'Gone', message: 'Nothing here.'),
        ),
      ),
    );

    final title = tester.widget<Text>(find.text('Gone'));
    expect(title.style?.color, const Color(0xFF112233));
    expect(title.style?.fontSize, 30);
    final message = tester.widget<Text>(find.text('Nothing here.'));
    expect(message.style?.color, const Color(0xFF445566));

    final icon = tester.widget<Icon>(find.byIcon(Icons.search_off));
    expect(icon.size, 64);

    final box = tester.widget<ConstrainedBox>(
      find
          .ancestor(
            of: find.text('Gone'),
            matching: find.byType(ConstrainedBox),
          )
          .first,
    );
    expect(box.constraints.maxWidth, 320);
  });

  testWidgets('an inline failure card uses the same tokens', (tester) async {
    await tester.pumpWidget(
      _app(
        const Scaffold(
          body: vc.VyuhFailureScope(
            failure: _notFound,
            child: vc.FailureCard(title: 'Gone', message: 'Nothing here.'),
          ),
        ),
      ),
    );

    expect(tester.widget<Text>(find.text('Gone')).style?.fontSize, 30);
    expect(
      tester.widget<Text>(find.text('Nothing here.')).style?.color,
      const Color(0xFF445566),
    );
    expect(find.byIcon(Icons.search_off), findsOneWidget);
  });

  testWidgets('kinds without a custom icon keep the default', (tester) async {
    await tester.pumpWidget(
      _app(
        const vc.VyuhFailureScope(
          failure: vc.VyuhFailure(kind: vc.FailureKind.init, title: 'Down'),
          child: vc.FailurePage(title: 'Down'),
        ),
      ),
    );
    expect(find.byIcon(Icons.power_off_rounded), findsOneWidget);
  });

  test('failure tokens merge, copy and interpolate', () {
    final resolved = vc.VyuhThemeExtension.fallback(ThemeData().colorScheme);
    expect(resolved.failureIconSize, 40);
    expect(resolved.failureMaxWidth, 480);
    expect(resolved.failureIcons, isEmpty);

    final copy = _style.copyWith(
      failureIconSize: 10,
      failureMaxWidth: 100,
      failureTitleStyle: const TextStyle(fontSize: 12),
      failureMessageStyle: const TextStyle(fontSize: 11),
      failureIcons: const {vc.FailureKind.init: Icons.bolt},
    );
    expect(copy.failureIconSize, 10);
    expect(copy.failureMaxWidth, 100);
    expect(copy.failureTitleStyle?.fontSize, 12);
    expect(copy.failureMessageStyle?.fontSize, 11);
    expect(copy.failureIcons, {vc.FailureKind.init: Icons.bolt});
    expect(_style.copyWith().failureIconSize, 64);

    final mid = copy.lerp(_style, 0.5);
    expect(mid.failureIconSize, 37);
    expect(mid.failureMaxWidth, 210);
    expect(mid.failureTitleStyle?.fontSize, 21);
    expect(mid.failureIcons, _style.failureIcons);
    expect(copy.lerp(_style, 0.2).failureIcons, copy.failureIcons);
  });
}
