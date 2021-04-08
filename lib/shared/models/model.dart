import 'package:king_investor/shared/notifications/notifiable.dart';
import 'package:uuid/uuid.dart';

abstract class Model extends Notifiable {
  String _objectId;
  DateTime _createdAt;

  Model(String objectId, DateTime createdAt) {
    _objectId = objectId ?? Uuid().v1().replaceAll('-', '').substring(0, 10);
    _createdAt = createdAt ?? DateTime.now();
  }

  String get objectId => _objectId;
  DateTime get createdAt => _createdAt;

  set setObjectId(String objectId) {
    if (objectId != null) _objectId = objectId;
  }

  set setCreatedAt(DateTime createdAt) {
    if (createdAt != null) _createdAt = createdAt;
  }
}
