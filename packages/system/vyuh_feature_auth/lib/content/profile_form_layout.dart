import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_auth/content/profile_card.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart'
    hide Card, Divider;

part 'profile_form_layout.g.dart';

@JsonSerializable()
final class ProfileCardLayout extends LayoutConfiguration<ProfileCard> {
  static const schemaName = '${ProfileCard.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Profile Card Layout',
    fromJson: ProfileCardLayout.fromJson,
  );

  ProfileCardLayout() : super(schemaType: typeDescriptor.schemaType);

  factory ProfileCardLayout.fromJson(Map<String, dynamic> json) =>
      _$ProfileCardLayoutFromJson(json);

  @override
  Widget build(BuildContext context, ProfileCard content) {
    final user = vyuh.auth.currentUser;
    if (user.isUnknown) {
      return _UnknownUserCard(content: content);
    }

    return _LoggedInUser(content: content);
  }
}

class _LoggedInUser extends StatelessWidget {
  final ProfileCard content;
  const _LoggedInUser({required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final user = vyuh.auth.currentUser;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 100 + 16 + 8,
                child: Container(color: theme.colorScheme.primary),
              ),
              Container(
                width: 200 + 8,
                height: 200 + 8,
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: theme.colorScheme.surface, width: 8),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]),
                child: ClipOval(
                  child: user.photoUrl != null
                      ? ContentImage(
                          url: user.photoUrl!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 128,
                          height: 128,
                          color: theme.colorScheme.primaryContainer,
                          child: const Icon(Icons.person),
                        ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              children: [
                SelectableText(user.name ?? 'N/A',
                    style: theme.textTheme.headlineMedium),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.email_outlined),
                      label: SelectableText(user.email ?? 'N/A'),
                    ),
                    Chip(
                      avatar: const Icon(Icons.phone),
                      label: SelectableText(user.phoneNumber ?? 'N/A'),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Login Method',
                      style: theme.textTheme.labelMedium
                          ?.apply(color: theme.disabledColor),
                    ),
                    Text(user.loginMethod.label()),
                    Icon(user.loginMethod.icon(), size: 24),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    Text(
                      'Created On',
                      style: theme.textTheme.labelMedium
                          ?.apply(color: theme.disabledColor),
                    ),
                    Text(DateFormat('MMM d, yyyy hh:mm:ss a')
                        .format(user.creationTime!)),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    Text(
                      'Last Sign In On',
                      style: theme.textTheme.labelMedium
                          ?.apply(color: theme.disabledColor),
                    ),
                    Text(DateFormat('MMM d, yyyy hh:mm:ss a')
                        .format(user.lastSignInTime!)),
                  ],
                ),
                const Divider(),
                _LogoutButton(content: content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UnknownUserCard extends StatelessWidget {
  final ProfileCard content;
  const _UnknownUserCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8,
          children: [
            Text(vyuh.auth.currentUser.name ?? 'Unknown/Anonymous User',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            OutlinedButton(
              onPressed: () async {
                content.loginAction?.execute(context);
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  Icon(Icons.login),
                  Text('Login'),
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
  final ProfileCard content;
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
        widget.content.logoutAction?.execute(context);
      }
    });
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      if (_future.value.status == FutureStatus.pending) {
        return vyuh.widgetBuilder.contentLoader(context);
      }

      return Column(
        children: [
          OutlinedButton(
            onPressed: () async {
              runInAction(() => _future.value = ObservableFuture(
                    vyuh.auth.logout().then(
                      (_) {
                        if (context.mounted) {
                          widget.content.logoutAction?.execute(context);
                        }
                      },
                    ),
                  ));
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.logout),
                SizedBox(width: 8),
                Text('Logout'),
              ],
            ),
          ),
          if (_future.value.status == FutureStatus.rejected)
            vyuh.widgetBuilder.errorView(
              context,
              error: _future.value.error,
              title: 'Failed to logout',
            )
        ],
      );
    });
  }
}
