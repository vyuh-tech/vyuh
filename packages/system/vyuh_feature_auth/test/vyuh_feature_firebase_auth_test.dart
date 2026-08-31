import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_feature_auth/vyuh_feature_auth.dart';

void main() {
  group('reactive auth forms', () {
    test('email and password require valid typed values', () {
      final form = emailPasswordAuthForm();
      addTearDown(form.dispose);

      expect(form.valid, isFalse);

      form.control(emailControlName).value = 'invalid';
      form.control(passwordControlName).value = 'secret';
      expect(form.valid, isFalse);

      form.control(emailControlName).value = 'person@example.com';
      expect(form.valid, isTrue);
      expect(form.value, {
        emailControlName: 'person@example.com',
        passwordControlName: 'secret',
      });
    });

    test('phone and OTP reject invalid data and retain string values', () {
      final form = phoneOtpAuthForm();
      addTearDown(form.dispose);

      form.control(phoneControlName).value = '123';
      form.control(otpControlName).value = 'abc';
      expect(form.valid, isFalse);

      form.control(phoneControlName).value = '+919876543210';
      form.control(otpControlName).value = '123456';
      expect(form.valid, isTrue);
      expect(form.control(phoneControlName).value, isA<String>());
      expect(form.control(otpControlName).value, isA<String>());
    });
  });
}
