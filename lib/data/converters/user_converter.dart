import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/value_objects/email.dart';
import 'package:king_investor/domain/value_objects/name.dart';

class UserConverter {
  User fromMapToModel(map) {
    return User.fromServer(
      map[kObjectId],
      map[kCreatedAt],
      Name(map[kFirstName], map[kLastName]),
      Email(map[kEmail]),
      map[kSessionToken],
      map[kEmailVerified],
    );
  }

  Map fromModelToMap(User user) {
    return {
      kObjectId: user.objectId,
      kCreatedAt: user.createdAt,
      kFirstName: user.name.firstName,
      kLastName: user.name.lastName,
      kEmail: user.email.address,
    };
  }
}
