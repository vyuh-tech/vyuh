import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'open_in_dialog.g.dart';

@JsonSerializable()
final class OpenInDialogAction extends ActionConfiguration {
  static const schemaName = 'vyuh.action.openInDialog';
  static final typeDescriptor = TypeDescriptor(
    schemaType: OpenInDialogAction.schemaName,
    title: 'Open in Dialog Action',
    fromJson: OpenInDialogAction.fromJson,
  );

  final DialogBehavior behavior;
  final LinkType linkType;
  final String? url;
  final ObjectReference? route;

  OpenInDialogAction({
    super.title,
    this.behavior = DialogBehavior.modalBottomSheet,
    this.linkType = LinkType.url,
    this.url,
    this.route,
  }) : super(schemaType: schemaName);

  factory OpenInDialogAction.fromJson(Map<String, dynamic> json) =>
      _$OpenInDialogActionFromJson(json);

  @override
  FutureOr<void> execute(BuildContext context,
      {Map<String, dynamic>? arguments}) {
    final theme = Theme.of(context);

    switch (behavior) {
      case DialogBehavior.modalBottomSheet:
        showModalBottomSheet(
          context: context,
          enableDrag: true,
          clipBehavior: Clip.antiAlias,
          isDismissible: true,
          showDragHandle: true,
          useSafeArea: true,
          builder: (context) => _dialogContent(context),
        );
        break;
      case DialogBehavior.fullscreen:
        showDialog(
          context: context,
          barrierDismissible: true,
          useSafeArea: false,
          builder: (context) => Dialog.fullscreen(
            backgroundColor: theme.colorScheme.surface,
            child: SafeArea(
              child: Column(children: [
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton.filled(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.close))),
                Expanded(child: _dialogContent(context)),
              ]),
            ),
          ),
        );
        break;
    }
  }

  _dialogContent(BuildContext context) {
    return vyuh.content.buildRoute(
      context,
      url: url == null ? null : Uri.tryParse(url!),
      routeId: route?.ref,
    );
  }
}
