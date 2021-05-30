import 'package:king_investor/shared/notifications/notifiable.dart';

abstract class ValueObject extends Notifiable {
  String get firstNotification => notifications.isEmpty ? '' : notifications.first.message;
}
