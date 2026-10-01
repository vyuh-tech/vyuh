import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:vyuh_feature_auth/ui/form_fields.dart';

void main() {
  testWidgets(
    'Material UI field updates its control and reflects programmatic edits',
    (tester) async {
      final form = emailAuthForm();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReactiveForm(
              formGroup: form,
              child: EmailField(submit: () {}),
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'user@example.com');
      expect(form.control(emailControlName).value, 'user@example.com');
      form.control(emailControlName).value = 'next@example.com';
      await tester.pump();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'next@example.com',
      );
      await tester.pumpWidget(const SizedBox());
      form.dispose();
    },
  );
  testWidgets('validation uses the configured plain-language messages', (
    tester,
  ) async {
    final form = emailAuthForm();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReactiveForm(
            formGroup: form,
            child: EmailField(submit: () {}),
          ),
        ),
      ),
    );
    form.markAllAsTouched();
    await tester.pump();
    expect(find.text('Email is required'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'invalid');
    await tester.pump();
    expect(find.text('Enter a valid email address'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    form.dispose();
  });
  testWidgets(
    'password visibility retains the value and Material UI controller',
    (tester) async {
      final form = emailPasswordAuthForm();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReactiveForm(
              formGroup: form,
              child: PasswordField(
                showPasswordVisibilityToggle: true,
                submit: () {},
              ),
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'password');
      expect(
        tester.widget<TextField>(find.byType(TextField)).obscureText,
        isTrue,
      );
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();
      expect(
        tester.widget<TextField>(find.byType(TextField)).obscureText,
        isFalse,
      );
      expect(form.control(passwordControlName).value, 'password');
      await tester.pumpWidget(const SizedBox());
      form.dispose();
    },
  );
}
