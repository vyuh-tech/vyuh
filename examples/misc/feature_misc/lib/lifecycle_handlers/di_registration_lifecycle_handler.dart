import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'di_registration_lifecycle_handler.g.dart';

final class TestStore {
  final String title;

  TestStore(this.title);
}

@JsonSerializable()
final class DIRegistrationLifecycleHandler extends RouteLifecycleConfiguration {
  DIRegistrationLifecycleHandler()
      : super(schemaType: 'misc.lifecycleHandler.diRegistration');

  static const schemaName = 'misc.lifecycleHandler.diRegistration';
  static final typeDescriptor = TypeDescriptor(
      schemaType: schemaName,
      fromJson: DIRegistrationLifecycleHandler.fromJson,
      title: 'DI Registration Lifecycle Handler');

  factory DIRegistrationLifecycleHandler.fromJson(Map<String, dynamic> json) =>
      _$DIRegistrationLifecycleHandlerFromJson(json);

  @override
  Future<void> init(BuildContext context, RouteBase route) async {
    context.di.register(TestStore('Hello Scoped DI'));
  }

  @override
  Future<void> dispose() async {}
}
