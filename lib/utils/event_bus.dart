import 'package:event_bus/event_bus.dart';

class SynchronizationDoneEvent {
  int failedSyncCount;

  SynchronizationDoneEvent({required this.failedSyncCount});
}

class AppEventBus {
  static final _instance = EventBus();

  AppEventBus._();

  static EventBus getInstance() {
    return _instance;
  }
}