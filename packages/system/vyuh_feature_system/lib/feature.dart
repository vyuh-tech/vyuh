import 'package:flutter/material.dart' hide Card, Divider, Route;
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/action/alert.dart';
import 'package:vyuh_feature_system/action/delay.dart';
import 'package:vyuh_feature_system/condition/current_platform.dart';
import 'package:vyuh_feature_system/condition/current_theme_mode.dart';
import 'package:vyuh_feature_system/condition/screen_size.dart';
import 'package:vyuh_feature_system/condition/user_authenticated.dart';
import 'package:vyuh_feature_system/content/card/button_layout.dart';
import 'package:vyuh_feature_system/content/document_view/document_list_layout.dart';
import 'package:vyuh_feature_system/content/document_view/document_section_layout.dart';
import 'package:vyuh_feature_system/content/group/carousel_layout.dart';
import 'package:vyuh_feature_system/content/video_player.dart';
import 'package:vyuh_feature_system/content_modifiers/theme_modifier.dart';
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
            context,
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
        Card.descriptor(layouts: [
          DefaultCardLayout.typeDescriptor,
          ListItemCardLayout.typeDescriptor,
          ButtonCardLayout.typeDescriptor,
          CardConditionalLayout.typeDescriptor,
        ]),
        GroupDescriptor(layouts: [
          CarouselGroupLayout.typeDescriptor,
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

                return style.apply(
                  decorationColor: theme.colorScheme.primary,
                  decorationStyle: TextDecorationStyle.solid,
                  decoration: TextDecoration.underline,
                  fontWeightDelta: 2,
                  shadows: [
                    Shadow(
                      color: theme.colorScheme.primary,
                      offset: const Offset(0, -2),
                    ),
                  ],
                  color: Colors.transparent,
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
                      ],
                    ),
                  ),
                );
              },
            )
          ],
          blocks: [
            BlockItemDescriptor(
              type: Unknown.typeDescriptor,
              builder: (context, content) =>
                  vyuh.content.buildContent(context, content as Unknown),
            ),
            BlockItemDescriptor(
              type: TypeDescriptor(
                schemaType: TextBlockItem.schemaName,
                fromJson: TextBlockItem.fromJson,
                title: 'Text Block',
              ),
              builder: (_, content) =>
                  PortableTextBlock(model: content as TextBlockItem),
            ),
            BlockItemDescriptor(
              type: Card.typeDescriptor,
              builder: (context, content) =>
                  vyuh.content.buildContent(context, content as Card),
            ),
            BlockItemDescriptor(
              type: Group.typeDescriptor,
              builder: (context, content) =>
                  vyuh.content.buildContent(context, content as Group),
            ),
            BlockItemDescriptor(
              type: Divider.typeDescriptor,
              builder: (context, content) =>
                  vyuh.content.buildContent(context, content as Divider),
            ),
          ],
        ),
        DividerDescriptor(),
        APIContentDescriptor(
          configurations: [JsonPathApiConfiguration.typeDescriptor],
        ),
        DocumentViewDescriptor(
          layouts: [
            DocumentViewConditionalLayout.typeDescriptor,
          ],
        ),
        DocumentSectionViewDescriptor(
          layouts: [
            DocumentSectionViewConditionalLayout.typeDescriptor,
          ],
        ),
        DocumentListViewDescriptor(
          layouts: [
            DocumentListViewConditionalLayout.typeDescriptor,
          ],
        ),
      ],
      contentBuilders: [
        Route.contentBuilder,
        Card.contentBuilder,
        Group.contentBuilder,
        Conditional.contentBuilder,
        ConditionalRoute.contentBuilder,

        // This is defined explicitly because the ContentBuilder type is defined
        // in vyuh_extension_content and not in vyuh_core
        UnknownContentBuilder(),

        Empty.contentBuilder,
        PortableTextContent.contentBuilder,
        Divider.contentBuilder,
        Accordion.contentBuilder,
        APIContent.contentBuilder,
        VideoPlayerItem.contentBuilder,
        DocumentView.contentBuilder,
        DocumentSectionView.contentBuilder,
        DocumentListView.contentBuilder,
      ],
      contentModifiers: [
        ThemeModifier.typeDescriptor,
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
        DelayAction.typeDescriptor,
      ],
    ),
  ],
  extensionBuilders: [
    ContentExtensionBuilder(),
  ],
);
