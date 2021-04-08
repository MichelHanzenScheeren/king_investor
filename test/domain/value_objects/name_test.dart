import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/domain/value_objects/name.dart';

main() {
  group('Tests about send null to firstName in Name instance', () {
    Name name = Name(null, 'Silva');
    test('Should be invalid when firstName is null', () {
      expect(name.isValid, isFalse);
    });
    test('Should has a Notification when firstName is null', () {
      expect(name.notifications.length, 1);
    });
    test('Should has expected key in Notification when firstName is null', () {
      expect(name.notifications[0].message, 'O primeiro nome não pode ser nulo ou vazio');
    });
    test('Should has expected message in Notification when firstName is null', () {
      expect(name.notifications[0].key, 'Name.firstName');
    });
  });

  test('Should be invalid when send empty String to firstName in Name instance', () {
    Name name = Name('', 'Silva');
    expect(name.isValid, isFalse);
  });

  test('Should be invalid when send String with lower length to firstName in Name instance', () {
    Name name = Name('Aa', 'Silva');
    expect(name.isValid, isFalse);
  });

  test('Should be invalid when send String with greater length to firstName in Name instance', () {
    Name name = Name('0123456789012345678901234567890', 'Silva');
    expect(name.isValid, isFalse);
  });

  test('Should be valid when send corret Name', () {
    Name name = Name('Ana', 'Silva');
    expect(name.isValid, isTrue);
  });

  group('Tests about edit Name', () {
    Name name = Name('Ana', 'Silva');
    test('Should be invalid and not edit when try to change Name with incorrect value', () {
      name.setName('Ana', null);
      expect(name.isValid, isFalse);
      expect(name.firstName, 'Ana');
      expect(name.lastName, 'Silva');
    });
    test('Should be valid and edit values when try to change Name with correct value', () {
      name.setName('Beatriz', 'Sampaio');
      expect(name.isValid, isTrue);
      expect(name.firstName, 'Beatriz');
      expect(name.lastName, 'Sampaio');
    });
  });
}
