import 'package:vyuh_core/vyuh_core.dart';

/// `DIPlugin` is an abstract class that extends the [Plugin] class.
///
/// It is associated with the Dependency Injection (DI) Plugin type and
/// includes methods for registering, unregistering, retrieving, and
/// checking the existence of instances in the DI container.
///
/// This class also includes lifecycle management methods and integrates
/// functionality from the [PreloadedPlugin] mixin.
abstract class DIPlugin extends Plugin with PreloadedPlugin {
  /// Constructs a `DIPlugin` instance with the given [name] and [title].
  DIPlugin({required super.name, required super.title}) : super();

  /// Registers an instance of any Object type with the DI container.
  ///
  /// The [instance] parameter is the object to be registered. Optionally,
  /// a [name] can be assigned to the instance for later retrieval.
  void register<T extends Object>(T instance, {String? name});

  /// Registers a function that produces an instance of any Object type.
  ///
  /// The instance produced by the [fn] function is created lazily when
  /// it is required. Optionally, a [name] can be assigned for later retrieval.
  void registerLazy<T extends Object>(T Function() fn, {String? name});

  /// Registers a factory function that produces a new instance each time it is called.
  ///
  /// The [fn] function is used to generate the instance. Optionally,
  /// a [name] can be assigned for later retrieval.
  void registerFactory<T extends Object>(T Function() fn, {String? name});

  /// Removes the instance of the specified type from the DI container.
  ///
  /// If a [name] is provided, it removes the named instance of the type [T].
  void unregister<T extends Object>({String? name});

  /// Retrieves the registered instance of type [T] from the DI container.
  ///
  /// If a [name] is provided, it retrieves the named instance of the type [T].
  /// Throws an exception if the instance does not exist.
  T get<T extends Object>({String? name});

  /// Checks if an instance of the specified type is registered in the DI container.
  ///
  /// If a [name] is provided, it checks the named instance of the type [T].
  bool has<T extends Object>({String? name});

  /// Clears all instances registered in the DI container.
  ///
  /// This method is asynchronous to handle potential cleanup tasks.
  Future<void> reset();
}

/// An extension on the `DIPlugin` class to provide asynchronous lazy dependency injection.
///
/// This extension introduces two key functions:
///
/// 1. [registerAsync]:
///    Registers an asynchronous function that initializes a dependency lazily. The function
///    is executed only when the dependency is first requested.
///
/// 2. [getAsync]:
///    Retrieves the registered asynchronous dependency.
///
/// Example:
/// ```dart
/// final diPlugin = DIPlugin();
///
/// // Registering an async dependency
/// diPlugin.registerAsync<SomeService>(() async {
///   await Future.delayed(Duration(seconds: 2));
///   return SomeService();
/// });
///
/// // Retrieving the registered dependency
/// final serviceFuture = diPlugin.getAsync<SomeService>();
/// serviceFuture.then((service) => print('Service initialized: $service'));
/// ```
extension AsyncLazyDI on DIPlugin {
  /// Registers a lazily initialized asynchronous dependency in the dependency injection container.
  ///
  /// The provided function [fn] must return a `Future<T>`, where `T` is the type of the dependency.
  /// The dependency initialization will only occur when it is first requested.
  ///
  /// - [T]: The type of the dependency being registered.
  /// - [fn]: A function that returns a `Future<T>` which initializes the dependency.
  /// - [name]: An optional string to identify the dependency. This is useful for
  ///   distinguishing between multiple instances of the same type.
  ///
  /// Example:
  /// ```dart
  /// diPlugin.registerAsync<MyService>(() async {
  ///   return MyService();
  /// }, name: 'myService');
  /// ```
  void registerAsync<T extends Object>(
      Future<T> Function() fn,
      {String? name}
      ) => registerLazy<Future<T>>(fn, name: name);

  /// Retrieves an asynchronously initialized dependency from the dependency injection container.
  ///
  /// This function returns the registered `Future<T>` for the specified dependency type [T].
  ///
  /// - [T]: The type of the dependency to retrieve.
  /// - [name]: An optional string to specify the name of the dependency.
  ///
  /// Returns:
  /// A `Future<T>` representing the asynchronous dependency.
  ///
  /// Example:
  /// ```dart
  /// final myServiceFuture = diPlugin.getAsync<MyService>(name: 'myService');
  /// myServiceFuture.then((service) => print('Service initialized: $service'));
  /// ```
  Future<T> getAsync<T extends Object>({String? name}) => get<Future<T>>(name: name);
}
