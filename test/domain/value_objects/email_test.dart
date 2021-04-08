import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/domain/value_objects/email.dart';

main() {
  test('should be invalid when address is null', () {
    Email email = Email(null);
    expect(email.isValid, isFalse);
  });

  test('should be invalid when address is incorrect email (without @)', () {
    Email email = Email('ana.com');
    expect(email.isValid, isFalse);
  });

  test('should be invalid when address is incorrect email (without .*)', () {
    Email email = Email('ana@teste');
    expect(email.isValid, isFalse);
  });

  test('should be invalid when address is incorrect email (with two or more @)', () {
    Email email = Email('ana@gma@il.com');
    expect(email.isValid, isFalse);
  });

  test('should be valid when address is correct email', () {
    Email email = Email('ana@gmail.com');
    expect(email.isValid, isTrue);
  });
}
