import 'package:flutter/material.dart';

/// Represents a user of the application.
class User {
  /// The unique identifier of the user.
  final String id;

  /// The name of the user. This could include the first name, last name or display name.
  final String? name;

  /// The email of the user.
  final String? email;

  /// The phone number of the user.
  final String? phoneNumber;

  /// The URL of the user's photo.
  final String? photoUrl;

  /// The method used to login.
  final LoginMethod loginMethod;

  /// Create a new user with the given parameters.
  const User({
    required this.loginMethod,
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.photoUrl,
  });

  /// Returns true if this user is the unknown user.
  bool get isUnknown => this == unknown;

  /// A constant unknown user.
  static const unknown = User(
    id: 'unknown',
    name: 'Unknown User',
    loginMethod: LoginMethod.unknown,
  );
}

/// Represents the method used to login.
enum LoginMethod {
  /// The method is unknown.
  unknown,

  /// The user is anonymous.
  anonymous,

  /// The user logged in using email and password.
  emailPassword,

  /// The user logged in using phone OTP.
  phoneOtp,

  /// The user logged in using email link.
  emailLink,

  /// The user logged in using Google.
  google,

  /// The user logged in using Facebook/Meta
  facebook,

  /// The user logged in using Apple.
  apple,

  /// The user logged in using Twitter.
  twitter,

  /// The user logged in using GitHub.
  github,

  /// The user logged in using LinkedIn.
  linkedin,

  /// The user logged in using Microsoft.
  microsoft;

  /// Returns the icon for this login method. This is useful only in the developer tools or UI.
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

  /// Returns the label for this login method. This is useful only in the developer tools or UI.
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
