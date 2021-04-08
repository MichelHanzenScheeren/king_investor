import 'dart:collection';

import 'package:king_investor/shared/notifications/notification.dart';

abstract class Notifiable {
  List<Notification> _notifications;

  Notifiable() {
    _notifications = <Notification>[];
  }

  UnmodifiableListView<Notification> get notifications => UnmodifiableListView<Notification>(_notifications);

  bool get isValid => _notifications.length == 0;

  void addNotification(String key, String message) {
    _notifications.add(Notification(key, message));
  }

  void addNotifications(Notifiable notifiable) {
    _notifications.addAll(notifiable.notifications.toList());
  }

  void clearNotifications() {
    _notifications.clear();
  }
}
