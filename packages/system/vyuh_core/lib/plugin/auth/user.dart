import 'package:flutter/material.dart';

class User {
  final String id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? photoUrl;
  final LoginMethod loginMethod;

  const User({
    required this.loginMethod,
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.photoUrl,
  });

  bool get isUnknown => this == unknown;

  static const unknown = User(
    id: 'unknown',
    name: 'Unknown User',
    loginMethod: LoginMethod.unknown,
  );
}

enum LoginMethod {
  unknown,
  anonymous,
  emailPassword,
  phoneOtp,
  emailLink,
  google,
  facebook,
  apple,
  twitter,
  github,
  linkedin,
  microsoft;

  IconData icon() {
    return switch (this) {
      LoginMethod.anonymous => Icons.person,
      LoginMethod.emailPassword => Icons.email,
      LoginMethod.phoneOtp => Icons.phone,
      LoginMethod.emailLink => Icons.link,
      LoginMethod.google ||
      LoginMethod.facebook ||
      LoginMethod.apple ||
      LoginMethod.twitter ||
      LoginMethod.github ||
      LoginMethod.linkedin ||
      LoginMethod.microsoft =>
        Icons.shield_outlined,
      _ => Icons.help,
    };
  }

  String label() {
    return switch (this) {
      LoginMethod.unknown => 'Unknown',
      LoginMethod.anonymous => 'Anonymous',
      LoginMethod.emailPassword => 'Email/Password',
      LoginMethod.phoneOtp => 'Phone OTP',
      LoginMethod.emailLink => 'Email Link',
      LoginMethod.google => 'Google',
      LoginMethod.facebook => 'Facebook',
      LoginMethod.apple => 'Apple',
      LoginMethod.twitter => 'Twitter',
      LoginMethod.github => 'GitHub',
      LoginMethod.linkedin => 'LinkedIn',
      LoginMethod.microsoft => 'Microsoft'
    };
  }
}
