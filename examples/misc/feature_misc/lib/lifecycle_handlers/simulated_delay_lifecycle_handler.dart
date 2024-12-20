import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'simulated_delay_lifecycle_handler.g.dart';

@JsonSerializable()
final class SimulatedDelayLifecycleHandler extends RouteLifecycleConfiguration {
  final int delay;

  static const String schemaName = 'misc.lifecycleHandler.simulatedDelay';
  static var typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: SimulatedDelayLifecycleHandler.fromJson,
    title: 'Simulated Delay Lifecycle Handler',
  );

  SimulatedDelayLifecycleHandler({this.delay = 1})
      : super(schemaType: schemaName);

  factory SimulatedDelayLifecycleHandler.fromJson(Map<String, dynamic> json) =>
      _$SimulatedDelayLifecycleHandlerFromJson(json);

  @override
  Future<void> dispose() async {}

  @override
  Future<void> init(BuildContext context, RouteBase route) {
    return Future.delayed(Duration(seconds: delay));
  }
}

final class TestStore {
  final Observable<int> count = 0.obs();
}
