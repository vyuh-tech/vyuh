import 'package:material_ui/material_ui.dart';

import 'portable_text_config.dart';

/// Gives a block built by [PortableTextConfig.buildBlock] its position in the
/// parent list (0-based), so block and container builders can vary by
/// position, e.g. drop the leading space of the first block.
class PortableBlockIndex extends InheritedWidget {
  /// The position of the block in its parent list (0-based).
  final int index;

  const PortableBlockIndex({
    super.key,
    required this.index,
    required super.child,
  });

  /// The index of the enclosing block, or `null` when the block was built
  /// without an index.
  static int? maybeOf(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PortableBlockIndex>()?.index;

  @override
  bool updateShouldNotify(final PortableBlockIndex oldWidget) =>
      index != oldWidget.index;
}
