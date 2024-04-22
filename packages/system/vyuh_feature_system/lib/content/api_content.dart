import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'api_content.g.dart';

@JsonSerializable()
final class APIContent extends ContentItem {
  static const schemaName = 'vyuh.apiContent';

  final bool showPending;
  final bool showError;

  @JsonKey(fromJson: typeFromFirstOfListJson<ApiConfiguration>)
  final ApiConfiguration? configuration;

  factory APIContent.fromJson(Map<String, dynamic> json) =>
      _$APIContentFromJson(json);

  APIContent({
    this.showError = kDebugMode,
    this.showPending = true,
    this.configuration,
  }) : super(schemaType: APIContent.schemaName);
}

abstract base class ApiConfiguration<T> implements SchemaItem {
  @override
  final String schemaType;

  final String? title;

  ApiConfiguration({required this.schemaType, this.title});

  Future<T?> invoke(BuildContext context);

  Widget build(BuildContext context, T? data);
}

class APIContentDescriptor extends ContentDescriptor {
  final List<TypeDescriptor<ApiConfiguration>>? configurations;

  APIContentDescriptor({this.configurations})
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

    final configs = descriptors.cast<APIContentDescriptor>().expand((element) =>
        element.configurations ?? <TypeDescriptor<ApiConfiguration>>[]);

    for (final config in configs) {
      vyuh.content.register<ApiConfiguration>(config);
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
    if (content.configuration == null) {
      return vyuh.widgetBuilder.errorView(
        title: 'Missing API Configuration',
        subtitle:
            'Could not find a matching API Configuration. Please ensure it has been registered with the correct schema type.',
        showRestart: false,
      );
    }

    return FutureBuilder<dynamic>(
      future: content.configuration?.invoke(context),
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
              title:
                  'API Error${content.configuration?.title != null ? ': ${content.configuration!.title}' : ''}',
              subtitle:
                  'Handler in context was "${content.configuration?.schemaType}"',
              error: snapshot.error,
              showRestart: false,
            );
          } else {
            // Show data when API call is successful
            return content.configuration?.build(context, snapshot.data) ??
                empty;
          }
        } else {
          // In case, the future is neither in progress nor done.
          return empty;
        }
      },
    );
  }
}
