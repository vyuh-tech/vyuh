import 'package:get_it/get_it.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// GetItDIPlugin is a class that is final and it extends the [DIPlugin].
/// It uses the 'GetIt' package to manage dependency injection in the project.
///
/// It has several methods to manage dependencies like:
/// register a dependency, check if a dependency is already registered,
/// unregister a dependency, etc.
final class GetItDIPlugin extends DIPlugin {
  final _instance = GetIt.asNewInstance();

  final String? debugLabel;

  GetItDIPlugin({this.debugLabel})
      : super(name: 'vyuh.plugin.di.getIt', title: 'GetIt DI Plugin');

  @override
  Future<void> init() => _instance.reset();

  @override
  Future<void> dispose() async => _instance.reset();

  @override
  T get<T extends Object>({String? name}) {
    return _instance.get<T>(instanceName: name);
  }

  @override
  bool has<T extends Object>({String? name}) {
    return _instance.isRegistered<T>(instanceName: name);
  }

  @override
  void register<T extends Object>(T instance, {String? name}) {
    _instance.registerSingleton<T>(instance, instanceName: name);
  }

  @override
  void registerFactory<T extends Object>(T Function() fn, {String? name}) {
    _instance.registerFactory(fn, instanceName: name);
  }

  @override
  void registerLazy<T extends Object>(T Function() fn, {String? name}) {
    _instance.registerLazySingleton(fn, instanceName: name);
  }

  @override
  Future<void> reset() {
    return _instance.reset();
  }

  @override
  void unregister<T extends Object>({String? name}) {
    _instance.unregister<T>(instanceName: name);
  }
}
