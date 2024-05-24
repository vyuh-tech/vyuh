import 'package:vyuh_core/vyuh_core.dart';

/// `DIPlugin` is an abstract class that extends the [Plugin] class.
/// It is associated with the Dependency Injection (DI) Plugin type and
/// includes methods for registering, unregistering, retrieving, and
/// checking the existence of instances in the DI container.
abstract class DIPlugin extends Plugin {
  /// The `DIPlugin` constructor accepts two required parameters: `name` and `title`.
  DIPlugin({required super.name, required super.title})
      : super(pluginType: PluginType.di);

  /// Registers an instance of any Object type with the DI container.
  void register<T extends Object>(T instance);

  /// Registers a function that produces an instance of any Object type when called.
  /// The instance is created lazily, i.e., it is not created until it is required.
  void registerLazy<T extends Object>(T Function() fn);

  /// Registers a factory function that produces an instance of any Object type whenever it's called.
  void registerFactory<T extends Object>(T Function() fn);

  /// Removes the instance of the specified Object type from the DI container.
  void unregister<T extends Object>();

  /// Retrieves the registered instance of the specified Object type from the DI container.
  T get<T extends Object>();

  /// Checks if the instance of the specified Object type is registered in the DI container.
  bool has<T extends Object>();

  /// Clears all the instances registered in the DI container.
  Future<void> reset();
}
