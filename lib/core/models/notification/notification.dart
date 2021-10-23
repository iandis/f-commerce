import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class Notification {
  
  const Notification({
    required this.data,
    required this.remoteNotification,
  });

  final RemoteNotification? remoteNotification;
  final Map<String, dynamic> data;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
  
    return other is Notification &&
      other.remoteNotification == remoteNotification &&
      mapEquals(other.data, data);
  }

  @override
  int get hashCode => remoteNotification.hashCode ^ data.hashCode;
}
