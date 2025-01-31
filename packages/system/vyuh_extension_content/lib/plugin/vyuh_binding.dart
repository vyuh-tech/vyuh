import 'package:vyuh_core/vyuh_core.dart';

final class VyuhBinding {
  VyuhBinding._();

  static final instance = VyuhBinding._();

  ContentPlugin? _contentPlugin;
  ContentPlugin? get contentPlugin => _contentPlugin;

  void setContentPlugin(ContentPlugin? plugin) {
    _contentPlugin = plugin;
  }
}
