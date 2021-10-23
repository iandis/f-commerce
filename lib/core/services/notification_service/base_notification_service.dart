import 'dart:async';

import '/core/models/notification/notification.dart';

abstract class BaseNotificationService {
  Future<void> init();

  /// Returns a [StreamSubscription] of listening an event from FCM
  /// when the app is running and in background or terminated state
  StreamSubscription<Notification> onBackgroundNotification(
    void Function(Notification notification) onData,
  );

  /// Returns a [StreamSubscription] of user-selected notification
  /// (e.g. when user taps on a notification heads-up) when the app
  /// is in terminated state.
  StreamSubscription<Notification> onBackgroundNotificationOpened(
    void Function(Notification notification) onData,
  );

  /// Returns a [StreamSubscription] of listening an event from FCM
  /// when the app is running and is in foreground state
  StreamSubscription<Notification> onForegroundNotification(
    void Function(Notification notification) onData,
  );

  /// Returns a [StreamSubscription] of user-selected notification
  /// (e.g. when user taps on a notification heads-up) when the app
  /// is running.
  StreamSubscription<Notification> onForegroundNotificationOpened(
    void Function(Notification notification) onData,
  );

}
