import 'package:vyuh_core/plugin/event_plugin.dart';

/// An event indicating that the system is ready.
///
/// This event is emitted when the system initialization process is complete
/// and the platform is ready for operation. It can be used by listeners to
/// perform actions that require the system to be fully initialized.
final class SystemReadyEvent extends VyuhEvent<void> {
  /// Creates a new [SystemReadyEvent].
  SystemReadyEvent() : super(name: 'vyuh.event.systemReady');
}
