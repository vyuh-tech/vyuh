/// This is a library for rendering Portable Text from Sanity.io in Flutter.
/// It is based on the official Portable Text specification found at https://www.portabletext.org/.
///
/// Supported features:
/// - Text blocks
/// - Custom blocks
/// - Custom block containers
/// - Inline text marks
/// - Custom text styles
/// - Custom mark definitions
/// - Custom text mark recognizers
/// - Shared config across all Portable Text Widgets
///
library;

export 'model/markdef_descriptor.dart';
export 'model/text_block.dart';
export 'ui/portable_text_block.dart';
export 'ui/portable_text_config.dart';
export 'ui/portable_text_widget.dart';
