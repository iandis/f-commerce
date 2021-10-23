import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

import '/core/models/notification/notification.dart';
import 'base_notification_service.dart';

final BehaviorSubject<Notification> _backgroundMessageSubject = BehaviorSubject<Notification>();
final BehaviorSubject<Notification> _openedBackgroundMsgSubject = BehaviorSubject<Notification>();
final BehaviorSubject<Notification> _foregroundMessageSubject = BehaviorSubject<Notification>();
final BehaviorSubject<Notification> _openedForegroundMsgSubject = BehaviorSubject<Notification>();

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  final Notification backgroundNotif = Notification(
    data: message.data,
    remoteNotification: message.notification,
  );
  _backgroundMessageSubject.add(backgroundNotif);
}

class NotificationService implements BaseNotificationService {
  const NotificationService();
  // NotificationService({
  // this.channelId,
  // this.channelName,
  // this.channelDesc,
  // });

  // static const String _channelId = "fcommerce_notif_channel";
  // static const String _channelName = "f-commerce";
  // static const String _channelDesc = "f-commerce";

  // final String? channelId;
  // final String? channelName;
  // final String? channelDesc;

  // final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Future<void> init() async {
    await _requestIOSPermissions();
    // await _initLocalNotification();
    await _initFCM();
  }

  Future<void> _initFCM() async {
    await Firebase.initializeApp();

    dev.log(
      await FirebaseMessaging.instance.getToken() ?? 'null',
    );

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        final Notification foregroundNotif = Notification(
          data: message.data,
          remoteNotification: message.notification,
        );
        _foregroundMessageSubject.add(foregroundNotif);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        final Notification openedForegroundNotif = Notification(
          data: message.data,
          remoteNotification: message.notification,
        );
        _openedForegroundMsgSubject.add(openedForegroundNotif);
      },
    );

    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

    final RemoteMessage? openedBackgroundMsg = await FirebaseMessaging.instance.getInitialMessage();
    if (openedBackgroundMsg != null) {
      final Notification openedBackgroundNotif = Notification(
        data: openedBackgroundMsg.data,
        remoteNotification: openedBackgroundMsg.notification,
      );
      _openedBackgroundMsgSubject.add(openedBackgroundNotif);
    }
  }

  // Future<void> _initLocalNotification() async {
  //   const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const IOSInitializationSettings iosSettings = IOSInitializationSettings();
  //   const InitializationSettings initSettings = InitializationSettings(
  //     android: androidSettings,
  //     iOS: iosSettings,
  //   );

  //   final NotificationAppLaunchDetails? launchDetails = await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  //   if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
  //     _onSelectNotification(launchDetails.payload);
  //   }

  //   await _flutterLocalNotificationsPlugin.initialize(
  //     initSettings,
  //     onSelectNotification: _onSelectNotification,
  //   );
  // }

  // void _onSelectNotification(String? payload) {
  //   _selectedNotificationSubject.add(payload);
  // }

  Future<bool> _requestIOSPermissions() async {
    if (Platform.isIOS) {
      final NotificationSettings notifSettings = await FirebaseMessaging.instance.requestPermission();
      return notifSettings.authorizationStatus == AuthorizationStatus.authorized;
    }
    return true;
  }

  @override
  StreamSubscription<Notification> onBackgroundNotification(
    void Function(Notification notification) onData,
  ) {
    return _backgroundMessageSubject.listen(onData);
  }

  @override
  StreamSubscription<Notification> onBackgroundNotificationOpened(
    void Function(Notification notification) onData,
  ) {
    return _openedBackgroundMsgSubject.listen(onData);
  }

  @override
  StreamSubscription<Notification> onForegroundNotification(
    void Function(Notification notification) onData,
  ) {
    return _foregroundMessageSubject.listen(onData);
  }

  @override
  StreamSubscription<Notification> onForegroundNotificationOpened(
    void Function(Notification notification) onData,
  ) {
    return _openedForegroundMsgSubject.listen(onData);
  }

  // @override
  // Future<void> showNotification(
  //   int id,
  //   String? title,
  //   String? body,
  //   String? payload,
  // ) {
  //   final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     channelId ?? _channelId,
  //     channelName ?? _channelName,
  //     channelDescription: channelDesc ?? _channelDesc,
  //     icon: '@mipmap/ic_launcher',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     enableLights: true,
  //     ledOnMs: 1000,
  //     ledOffMs: 500,
  //   );

  //   const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();

  //   final NotificationDetails notificationDetails = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //     iOS: iOSPlatformChannelSpecifics,
  //   );

  //   return _flutterLocalNotificationsPlugin.show(
  //     id,
  //     title,
  //     body,
  //     notificationDetails,
  //     payload: payload,
  //   );
  // }

}
