import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/content/empty.dart';

part 'api_content.g.dart';

@JsonSerializable()
final class APIContent extends ContentItem {
  static const schemaName = 'vyuh.apiContent';

  final bool showPending;
  final bool showError;

  @JsonKey(fromJson: typeFromFirstOfListJson<APIHandler>)
  final APIHandler? handler;

  factory APIContent.fromJson(Map<String, dynamic> json) =>
      _$APIContentFromJson(json);

  APIContent({
    this.showError = kDebugMode,
    this.showPending = true,
    this.handler,
  }) : super(schemaType: APIContent.schemaName);
}

abstract base class APIHandler<T> {
  final String schemaType;

  APIHandler({required this.schemaType});

  Future<T?> invoke(BuildContext context);

  Widget buildData(BuildContext context, T? data);
}

class APIContentDescriptor extends ContentDescriptor {
  final List<TypeDescriptor<APIHandler>>? handlers;

  APIContentDescriptor({this.handlers})
      : super(schemaType: APIContent.schemaName, title: 'API Content');
}

final class APIContentBuilder extends ContentBuilder<APIContent> {
  APIContentBuilder()
      : super(
          content: TypeDescriptor(
            schemaType: APIContent.schemaName,
            title: 'API Content',
            fromJson: APIContent.fromJson,
          ),
          defaultLayout: DefaultAPIContentLayout(),
          defaultLayoutDescriptor: DefaultAPIContentLayout.typeDescriptor,
        );

  @override
  void init(List<ContentDescriptor> descriptors) {
    super.init(descriptors);

    final apiHandlers = descriptors.cast<APIContentDescriptor>().expand(
        (element) => element.handlers ?? <TypeDescriptor<APIHandler>>[]);

    for (final handler in apiHandlers) {
      vyuh.content.register<APIHandler>(handler);
    }
  }
}

final class DefaultAPIContentLayout extends LayoutConfiguration<APIContent> {
  static const schemaName = '${APIContent.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default APIContent Layout',
    fromJson: DefaultAPIContentLayout.fromJson,
  );

  DefaultAPIContentLayout() : super(schemaType: schemaName);

  factory DefaultAPIContentLayout.fromJson(Map<String, dynamic> json) =>
      DefaultAPIContentLayout();

  @override
  Widget build(BuildContext context, APIContent content) {
    return FutureBuilder<dynamic>(
      future: content.handler?.invoke(context),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (content.showPending &&
            (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.active)) {
          // Showing a loading spinner during API call
          return vyuh.widgetBuilder.contentLoader();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (content.showError && snapshot.hasError) {
            // Show error if API call resulted in an error
            return vyuh.widgetBuilder.errorView(
              title: 'API Error',
              subtitle:
                  'Handler in context was "${content.handler?.schemaType}"',
              error: snapshot.error,
              showRestart: false,
            );
          } else {
            // Show data when API call is successful
            return content.handler?.buildData(context, snapshot.data) ?? empty;
          }
        } else {
          // In case, the future is neither in progress nor done.
          return kDebugMode
              ? vyuh.widgetBuilder.errorView(
                  title: 'API Error',
                  error:
                      'Something went wrong invoking the api with ${content.handler?.schemaType}',
                  showRestart: false,
                )
              : empty;
        }
      },
    );
  }
}
