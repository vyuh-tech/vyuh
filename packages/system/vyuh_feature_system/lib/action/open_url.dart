import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'open_url.g.dart';

enum UrlLaunchMode {
  inApp,
  externalApp,
  platformDefault;

  LaunchMode get launchMode => switch (this) {
        UrlLaunchMode.inApp => LaunchMode.inAppWebView,
        UrlLaunchMode.externalApp => LaunchMode.externalApplication,
        UrlLaunchMode.platformDefault => LaunchMode.platformDefault,
      };
}

@JsonSerializable()
final class OpenUrlAction extends ActionConfiguration {
  static const schemaName = 'vyuh.action.openUrl';
  static final typeDescriptor = TypeDescriptor(
    schemaType: OpenUrlAction.schemaName,
    title: 'Open Url Action',
    fromJson: OpenUrlAction.fromJson,
  );

  final String? url;
  final UrlLaunchMode mode;

  OpenUrlAction({
    super.title,
    this.url,
    this.mode = UrlLaunchMode.platformDefault,
    super.isAwaited,
  }) : super(schemaType: schemaName);

  factory OpenUrlAction.fromJson(Map<String, dynamic> json) =>
      _$OpenUrlActionFromJson(json);

  @override
  FutureOr<void> execute(BuildContext context,
      {Map<String, dynamic>? arguments}) async {
    if (url == null || url!.isEmpty) {
      vyuh.log?.d('No url provided to open');
    }

    final canLaunch = await canLaunchUrlString(url!);
    if (canLaunch == false) {
      vyuh.log?.d('Unable to launch url: $url');
      return;
    }

    await launchUrlString(url!, mode: mode.launchMode);
  }
}
