import 'package:king_investor/domain/value_objects/email.dart';
import 'package:king_investor/domain/value_objects/name.dart';
import 'package:king_investor/shared/models/model.dart';

class User extends Model {
  final Name name;
  final Email email;

  User(String objectId, DateTime createdAt, this.name, this.email) : super(objectId, createdAt) {
    addNotifications(name);
    addNotifications(email);
  }
}
