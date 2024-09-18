/// A mixin to mark any plugin to be loaded before the Platform.
///
/// This mixin should be applied to plugins that need to be initialized
/// before the main platform initialization. It ensures that the
/// plugin is loaded at the correct time in the initialization sequence.
mixin PreloadedPlugin on Plugin {}

abstract class Plugin {
  final String name;
  final String title;

  Plugin({required this.name, required this.title});

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
