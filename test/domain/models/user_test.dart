import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/value_objects/email.dart';
import 'package:king_investor/domain/value_objects/name.dart';

main() {
  group('Tests about objectId and createdAt when pass null to them', () {
    User user = User(null, null, Name('Ana', 'Silva'), Email('ana@gmail.com'));
    test('should create valid objectId when pass null', () {
      expect(user.objectId, isInstanceOf<String>());
    });
    test('should create objectId with length 10', () {
      expect(user.objectId.length, 10);
    });
    test('should create valid createdAt when pass null', () {
      expect(user.createdAt, isInstanceOf<DateTime>());
    });
  });
  group('Tests about objectId and createdAt when pass valid values to them', () {
    User user = User('0123456789', DateTime(2021, 04, 07), Name('Ana', 'Silva'), Email('ana@gmail.com'));
    test('should to maintain objectId when pass valid value', () {
      expect(user.objectId, '0123456789');
    });
    test('should to maintain createAt when pass valid value', () {
      expect(user.createdAt.toString(), DateTime(2021, 04, 07).toString());
    });
  });

  test('should has Notifications when attributes are incorrect', () {
    User user = User(null, null, Name('Ana', ''), Email('ana@gmail.com'));
    expect(user.isValid, isFalse);
    expect(user.notifications.length, 1);
  });
}
