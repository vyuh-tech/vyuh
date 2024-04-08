class User {
  final String id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? photoUrl;
  final LoginMethod loginMethod;

  const User({
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.photoUrl,
    this.loginMethod = LoginMethod.anonymous,
  });

  bool get isAnonymous => this == anonymous;

  static const anonymous = User(
    id: 'anonymous',
  );
}

enum LoginMethod {
  anonymous,
  emailPassword,
  phoneOtp,
  emailLink,
  google,
  meta,
  apple,
  twitter,
  github,
  linkedin,
  microsoft,
}
