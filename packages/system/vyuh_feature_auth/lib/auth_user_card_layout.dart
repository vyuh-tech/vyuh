import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;

final class AuthUserCardLayout extends LayoutConfiguration<vf.Card> {
  static const schemaName = 'firebaseAuth.card.layout.user';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: (json) => AuthUserCardLayout(),
    title: 'Authenticated User Card',
  );

  AuthUserCardLayout() : super(schemaType: schemaName);

  @override
  Widget build(BuildContext context, vf.Card content) {
    final user = vyuh.auth.currentUser;
    if (user.isUnknown) {
      return _UnknownUserCard(content: content);
    }

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 64,
              foregroundImage:
                  user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
              child: user.photoUrl == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(
                width: 16), // Add some space between the avatar and the text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(TextSpan(
                    text: 'User: ',
                    children: [
                      TextSpan(
                          text: user.name ?? 'N/A',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  )),
                  Text('Email: ${user.email ?? 'N/A'}'),
                  Text('Phone: ${user.phoneNumber ?? 'N/A'}'),
                  Row(
                    children: [
                      Text('Method: ${user.loginMethod.label()}'),
                      const SizedBox(width: 8),
                      Icon(user.loginMethod.icon(), size: 24),
                    ],
                  ),
                  _LogoutButton(content: content),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnknownUserCard extends StatelessWidget {
  final vf.Card content;

  const _UnknownUserCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(vyuh.auth.currentUser.name ?? 'Unknown/Anonymous User',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () async {
                content.action?.execute(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.login),
                  const SizedBox(width: 8),
                  Text(content.secondaryAction?.title ?? 'Login'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatefulWidget {
  final vf.Card content;

  const _LogoutButton({required this.content});

  @override
  State<_LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<_LogoutButton> {
  final _future = Observable(ObservableFuture<void>(Future.value()));
  late final StreamSubscription<User?> _userSubscription;

  @override
  void initState() {
    super.initState();

    _userSubscription = vyuh.auth.userChanges.listen((user) {
      if (!mounted) {
        return;
      }

      if (user.isUnknown) {
        widget.content.secondaryAction?.execute(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      if (_future.value.status == FutureStatus.pending) {
        return const CircularProgressIndicator();
      }

      return OutlinedButton(
        onPressed: () async {
          runInAction(
              () => _future.value = ObservableFuture(vyuh.auth.logout()));
        },
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.logout),
            SizedBox(width: 8),
            Text('Logout'),
          ],
        ),
      );
    });
  }
}
