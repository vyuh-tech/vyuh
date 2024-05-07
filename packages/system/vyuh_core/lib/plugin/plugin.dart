enum PluginType {
  content,
  di,
  analytics,
  featureFlag,
  logger,
  storage,
  secureStorage,
  network,
  auth,
  notifications,
  ads,
  biometrics,
}

abstract class Plugin {
  final String name;
  final String title;
  final PluginType pluginType;

  Plugin({required this.pluginType, required this.name, required this.title});

  Future<void> init();
  Future<void> dispose();
}

enum FieldName {
  id,
  type,
  key,
  ref,
  updatedAt,
  createdAt,
}
