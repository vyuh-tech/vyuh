import 'package:flutter/material.dart' hide Card, Divider, Route;
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/action/alert.dart';
import 'package:vyuh_feature_system/condition/current_platform.dart';
import 'package:vyuh_feature_system/condition/current_theme_mode.dart';
import 'package:vyuh_feature_system/condition/screen_size.dart';
import 'package:vyuh_feature_system/condition/user_authenticated.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

final feature = FeatureDescriptor(
  name: 'system',
  title: 'System',
  description: 'The core building blocks of the framework',
  icon: Icons.hub,
  init: () async {
    vyuh.di.register(ThemeService());
    vyuh.di.register(BreakpointService());
  },
  routes: () => [
    GoRoute(
      path: '/__system_error__',
      pageBuilder: (context, state) {
        final exception = state.extra as (dynamic, StackTrace);

        return MaterialPage(
          child: vyuh.widgetBuilder.routeErrorView(
            title: 'System error',
            error: exception.$1.toString(),
            stackTrace: exception.$2,
          ),
        );
      },
    ),
    GoRoute(
      path: '/__system_navigate__',
      pageBuilder: (context, state) {
        switch (state.extra) {
          case Uri():
            return MaterialPage(child: WebView(uri: state.extra as Uri));
        }

        return const MaterialPage(
          child: Scaffold(body: Center(child: Text('No route'))),
        );
      },
    ),
  ],
  extensions: [
    ContentExtensionDescriptor(
      contents: [
        RouteDescriptor(routeTypes: [
          PageRouteType.typeDescriptor,
          DialogRouteType.typeDescriptor,
        ], layouts: [
          DefaultRouteLayout.typeDescriptor,
          TabsRouteLayout.typeDescriptor,
          SingleItemLayout.typeDescriptor,
          RouteConditionalLayout.typeDescriptor,
        ]),
        CardDescriptor(layouts: [
          ListItemCardLayout.typeDescriptor,
          CardConditionalLayout.typeDescriptor,
        ]),
        GroupDescriptor(layouts: [
          GridGroupLayout.typeDescriptor,
          ListGroupLayout.typeDescriptor,
          GroupConditionalLayout.typeDescriptor,
        ]),
        ConditionalDescriptor(),
        ConditionalRouteDescriptor(),
        UnknownDescriptor(),
        EmptyDescriptor(),
        PortableTextDescriptor(
          markDefs: [
            MarkDefDescriptor(
              schemaType: 'invokeAction',
              fromJson: InvokeActionMarkDef.fromJson,
              styleBuilder: (context, def, style) {
                final theme = Theme.of(context);

                return style.copyWith(
                  color: theme.colorScheme.primary,
                  decorationColor: theme.colorScheme.inversePrimary,
                  decorationStyle: TextDecorationStyle.dashed,
                  decoration: TextDecoration.underline,
                );
              },
              spanBuilder: (context, def, text, style) {
                return WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      (def as InvokeActionMarkDef).action.execute(context);
                    },
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      children: [
                        Text(
                          text,
                          style: style,
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
          blocks: [
            BlockItemDescriptor(
              schemaType: Unknown.schemaName,
              fromJson: Unknown.fromJson,
              builder: (context, content) =>
                  vyuh.content.buildContent(context, content as Unknown),
            ),
            BlockItemDescriptor(
              schemaType: TextBlockItem.schemaName,
              fromJson: TextBlockItem.fromJson,
              builder: (_, content) =>
                  PortableTextBlock(model: content as TextBlockItem),
            ),
            BlockItemDescriptor(
              schemaType: Card.schemaName,
              fromJson: Card.fromJson,
              builder: (context, content) =>
                  vyuh.content.buildContent(context, content as Card),
            ),
            BlockItemDescriptor(
              schemaType: Group.schemaName,
              fromJson: Group.fromJson,
              builder: (context, content) =>
                  vyuh.content.buildContent(context, content as Group),
            ),
            BlockItemDescriptor(
              schemaType: Divider.schemaName,
              fromJson: Divider.fromJson,
              builder: (context, content) =>
                  vyuh.content.buildContent(context, content as Divider),
            ),
          ],
        ),
        DividerDescriptor(),
        APIContentDescriptor(
          configurations: [JsonPathApiConfiguration.typeDescriptor],
        ),
      ],
      contentBuilders: [
        Route.contentBuilder,
        Card.contentBuilder,
        Group.contentBuilder,
        Conditional.contentBuilder,
        ConditionalRoute.contentBuilder,
        UnknownContentBuilder(),
        Empty.contentBuilder,
        PortableTextContent.contentBuilder,
        Divider.contentBuilder,
        Accordion.contentBuilder,
        APIContent.contentBuilder,
      ],
      conditions: [
        BooleanCondition.typeDescriptor,
        FeatureFlagCondition.typeDescriptor,
        UserAuthenticated.typeDescriptor,
        CurrentThemeMode.typeDescriptor,
        ScreenSize.typeDescriptor,
        CurrentPlatform.typeDescriptor,
      ],
      actions: [
        NavigationAction.typeDescriptor,
        NavigateBack.typeDescriptor,
        OpenUrlAction.typeDescriptor,
        OpenInDialogAction.typeDescriptor,
        ConditionalAction.typeDescriptor,
        RouteRefreshAction.typeDescriptor,
        ToggleThemeAction.typeDescriptor,
        RestartApplicationAction.typeDescriptor,
        ShowSnackBarAction.typeDescriptor,
        HideSnackBarAction.typeDescriptor,
        DrawerAction.typeDescriptor,
        ShowAlertAction.typeDescriptor,
      ],
    ),
  ],
  extensionBuilders: [
    ContentExtensionBuilder(),
  ],
);
