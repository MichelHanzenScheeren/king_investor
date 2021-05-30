import 'package:king_investor/domain/value_objects/email.dart';
import 'package:king_investor/domain/value_objects/name.dart';
import 'package:king_investor/shared/models/model.dart';

class User extends Model {
  final Name name;
  final Email email;
  String? _sessionToken;
  bool? _emailVerified;

  User(String? objectId, DateTime? createdAt, this.name, this.email) : super(objectId, createdAt) {
    addNotifications(name);
    addNotifications(email);
  }

  User.fromServer(
    String? objectId,
    DateTime? createdAt,
    this.name,
    this.email,
    String? sessionToken,
    bool? emailVerified,
  ) : super(objectId, createdAt) {
    addNotifications(name);
    addNotifications(email);
    _sessionToken = sessionToken ?? '';
    _emailVerified = emailVerified ?? false;
  }

  String get sessionToken => _sessionToken ?? '';
  bool get emailVerified => _emailVerified ?? false;
}
