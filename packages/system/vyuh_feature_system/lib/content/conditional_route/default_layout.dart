import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class DefaultConditionalRouteLayout
    extends LayoutConfiguration<ConditionalRoute> {
  static const schemaName = '${ConditionalRoute.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default ConditionalRoute Layout',
    fromJson: DefaultConditionalRouteLayout.fromJson,
  );

  DefaultConditionalRouteLayout()
      : super(schemaType: '${ConditionalRoute.schemaName}.layout.default');

  factory DefaultConditionalRouteLayout.fromJson(Map<String, dynamic> json) =>
      DefaultConditionalRouteLayout();

  @override
  Widget build(BuildContext context, ConditionalRoute content) {
    return _ConditionalRouteLayoutView(content: content);
  }
}

class _ConditionalRouteLayoutView extends StatelessWidget {
  final ConditionalRoute content;

  const _ConditionalRouteLayoutView({required this.content});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: content.evaluate(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return kDebugMode
                ? _ConditionalRouteDebugView(content: content)
                : vyuh.widgetBuilder.routeLoader(context);
          }

          if (snapshot.hasError || snapshot.hasData == false) {
            return vyuh.widgetBuilder.routeErrorView(context,
                error: snapshot.error,
                title: 'Failed to load Conditional Route');
          }

          return vyuh.content.buildContent(context, snapshot.data!);
        });
  }
}

class _ConditionalRouteDebugView extends StatelessWidget {
  final ConditionalRoute content;

  const _ConditionalRouteDebugView({required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Conditional Route',
                style: theme.textTheme.titleLarge,
              ),
              const LinearProgressIndicator(),
              const SizedBox(height: 8.0),
              Text.rich(TextSpan(
                text: 'Evaluating condition...',
                children: [
                  WidgetSpan(
                    child: Container(
                      color: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        content.condition?.configuration?.schemaType ?? 'N/A',
                        style: theme.textTheme.labelLarge?.apply(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  )
                ],
              )),
              const SizedBox(height: 8.0),
              Text(
                  'Possible Cases: ${content.cases?.length ?? 0}, (default: ${content.defaultCase ?? 'N/A'})'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var item in content.cases ?? <CaseRouteItem>[])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text.rich(TextSpan(
                          text: 'Case: ',
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                color: theme.colorScheme.primary,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  item.value ?? 'N/A',
                                  style: theme.textTheme.labelLarge?.apply(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
