import 'package:king_investor/shared/notifications/notifiable.dart';
import 'package:uuid/uuid.dart';

abstract class Model extends Notifiable {
  late String _objectId;
  late DateTime _createdAt;

  Model(String? objectId, DateTime? createdAt) {
    _objectId = objectId ?? Uuid().v1().replaceAll('-', '').substring(0, 10);
    _createdAt = createdAt ?? DateTime.now();
  }

  String get objectId => _objectId;
  DateTime get createdAt => _createdAt;
  String get firstNotification => notifications.isEmpty ? '' : notifications.first.message;

  void setObjectId(String? objectId) {
    if (objectId != null) _objectId = objectId;
  }

  void setCreatedAt(DateTime? createdAt) {
    if (createdAt != null) _createdAt = createdAt;
  }
}
