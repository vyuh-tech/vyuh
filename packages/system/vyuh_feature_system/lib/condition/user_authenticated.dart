import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content/condition.dart';

final class UserAuthenticated extends ConditionConfiguration {
  static const schemaName = 'vyuh.condition.userAuthenticated';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: (json) => UserAuthenticated(),
    title: 'User Authenticated',
  );

  UserAuthenticated() : super(schemaType: schemaName);

  @override
  Future<String?> execute(BuildContext context) {
    final isAuthenticated = switch (vyuh.auth.currentUser.loginMethod) {
      LoginMethod.unknown || LoginMethod.anonymous => false,
      _ => true,
    };

    return Future.value(isAuthenticated.toString());
  }
}
