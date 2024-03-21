import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' as vt;
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_extension_script/vyuh_extension_script.dart';
import 'package:vyuh_feature_system/content/card/list_item_layout.dart';
import 'package:vyuh_feature_system/content/portable_text/invoke_action.dart';
import 'package:vyuh_feature_system/content/route/default_layout.dart';
import 'package:vyuh_feature_system/content/route/dialog_layout.dart';
import 'package:vyuh_feature_system/content/route/route_type.dart';
import 'package:vyuh_feature_system/content/route/sliver_layout.dart';
import 'package:vyuh_feature_system/content/route/tabs.dart';
import 'package:vyuh_feature_system/content/web_view.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

final feature = FeatureDescriptor(
  name: 'system',
  title: 'System',
  description: 'The core building blocks of the framework',
  icon: Icons.hub,
  routes: () => [
    GoRoute(
      path: '/__system_error__',
      pageBuilder: (context, state) {
        return MaterialPage(
          child: vyuh.widgetBuilder.errorView(
            title: 'System error',
            error: state.extra.toString(),
            onRetry: () => vyuh.tracker.init(),
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
          TypeDescriptor(
            schemaType: PageRouteType.schemaName,
            title: 'Default Page Route',
            fromJson: PageRouteType.fromJson,
          ),
          TypeDescriptor(
            schemaType: DialogRouteType.schemaName,
            title: 'Default Dialog Route',
            fromJson: DialogRouteType.fromJson,
          ),
        ], layouts: [
          TypeDescriptor(
            schemaType: DefaultRouteLayout.schemaName,
            title: 'Default Layout',
            fromJson: DefaultRouteLayout.fromJson,
          ),
          TypeDescriptor(
            schemaType: TabsRouteLayout.schemaName,
            title: 'Tab Layout',
            fromJson: TabsRouteLayout.fromJson,
          ),
          TypeDescriptor(
            schemaType: SliverRouteLayout.schemaName,
            title: 'Sliver Layout',
            fromJson: SliverRouteLayout.fromJson,
          ),
          TypeDescriptor(
            schemaType: DialogRouteLayout.schemaName,
            title: 'Dialog Layout',
            fromJson: DialogRouteLayout.fromJson,
          ),
        ]),
        CardDescriptor(layouts: [
          TypeDescriptor(
            schemaType: ListItemCardLayout.schemaName,
            title: 'List Item Layout',
            fromJson: ListItemCardLayout.fromJson,
          ),
        ]),
        GroupDescriptor(layouts: [
          TypeDescriptor(
            schemaType: GridGroupLayout.schemaName,
            title: 'Grid Layout',
            fromJson: GridGroupLayout.fromJson,
          ),
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
              styleBuilder: (def, context, style) {
                final theme = Theme.of(context);

                return style.copyWith(
                  color: theme.colorScheme.primary,
                  decorationColor: theme.colorScheme.inversePrimary,
                  decorationStyle: TextDecorationStyle.double,
                  decoration: TextDecoration.underline,
                );
              },
              recognizerBuilder: (def, context) {
                return TapGestureRecognizer()
                  ..onTap = () {
                    (def as InvokeActionMarkDef).action.execute(context);
                  };
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
              schemaType: vf.Card.schemaName,
              fromJson: vf.Card.fromJson,
              builder: (context, content) =>
                  vyuh.content.buildContent(context, content as vf.Card),
            ),
            BlockItemDescriptor(
              schemaType: Group.schemaName,
              fromJson: Group.fromJson,
              builder: (context, content) =>
                  vyuh.content.buildContent(context, content as Group),
            ),
            BlockItemDescriptor(
              schemaType: vf.Divider.schemaName,
              fromJson: vf.Divider.fromJson,
              builder: (context, content) =>
                  vyuh.content.buildContent(context, content as vf.Divider),
            ),
          ],
        ),
        DividerDescriptor(),
        AccordionDescriptor()
      ],
      contentBuilders: [
        RouteContentBuilder(),
        CardContentBuilder(),
        GroupContentBuilder(),
        ConditionalContentBuilder(),
        ConditionalRouteBuilder(),
        UnknownContentBuilder(),
        EmptyContentBuilder(),
        PortableTextContentBuilder(),
        DividerContentBuilder(),
        AccordionContentBuilder(),
      ],
      conditions: [
        TypeDescriptor(
          schemaType: BooleanCondition.schemaName,
          title: 'Boolean Condition',
          fromJson: BooleanCondition.fromJson,
        )
      ],
      actions: [
        NavigationAction.typeDescriptor,
        JavaScriptAction.typeDescriptor,
      ],
    ),
    ScriptExtensionDescriptor(
        name: 'restart',
        function: (args) {
          return vyuh.tracker.init();
        }),
    ScriptExtensionDescriptor(
      name: 'switchTheme',
      function: (args) {
        final service = vyuh.di.get<vt.ThemeService>();
        service.changeTheme(
          service.currentMode.value == ThemeMode.light
              ? ThemeMode.dark
              : ThemeMode.light,
        );
      },
    ),
  ],
  extensionBuilders: [
    ScriptExtensionBuilder(),
    ContentExtensionBuilder(),
  ],
);
