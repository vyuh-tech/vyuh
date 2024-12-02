import 'package:vyuh_core/plugin/event_plugin.dart';

final class SystemReadyEvent extends VyuhEvent<void> {
  SystemReadyEvent() : super(name: 'vyuh.event.systemReady');
}
