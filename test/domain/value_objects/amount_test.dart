import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';

main() {
  test('Should be invalid when value is null', () {
    Amount amount = Amount(null);
    expect(amount.isValid, isFalse);
    expect(amount.value, 0.0);
  });

  test('Should be valid when value is a valid double', () {
    Amount amount = Amount(2.50);
    expect(amount.isValid, isTrue);
    expect(amount.value, 2.50);
  });

  test('Should be invalid when String is null and use Amount.fromString()', () {
    Amount amount = Amount.fromString(null);
    expect(amount.isValid, isFalse);
    expect(amount.value, 0.0);
  });

  test('Should be invalid when String is empty string and use Amount.fromString()', () {
    Amount amount = Amount.fromString('');
    expect(amount.isValid, isFalse);
    expect(amount.value, 0.0);
  });

  test('Should be invalid when String cannot be converted and use Amount.fromString()', () {
    Amount amount = Amount.fromString('Abc');
    expect(amount.isValid, isFalse);
    expect(amount.value, 0.0);
  });

  test('Should be valid when String can be converted and use Amount.fromString()', () {
    Amount amount = Amount.fromString('-2.50');
    expect(amount.isValid, isTrue);
    expect(amount.value, -2.50);
  });

  test('Should be valid when String contains comma and can be converted ', () {
    Amount amount = Amount.fromString('-2,50');
    expect(amount.isValid, isTrue);
    expect(amount.value, -2.50);
  });

  test('Should be invalid when try set with invalid double', () {
    Amount amount = Amount(2.0);
    amount.setValue(null);
    expect(amount.isValid, isFalse);
    expect(amount.value, 2.0);
  });

  test('Should be valid when try set with valid double', () {
    Amount amount = Amount(2.50);
    amount.setValue(5);
    expect(amount.isValid, isTrue);
    expect(amount.value, 5.0);
  });

  test('Should return valid string in toMonetary() e toPorcentage', () {
    Amount amount = Amount(2.50);
    expect(amount.toMonetary('BRL'), 'R\$ 2,50');
    expect(amount.toMonetary('USD'), '\$ 2,50');
    expect(amount.toMonetary('EUR'), 'EUR 2,50');
    expect(amount.toPorcentage(), '2,50%');
  });

  test('Should be invalid when set _mustBeGreaterThanZero true and send 0', () {
    Amount amount = Amount(0.0, mustBeGreaterThanZero: true);
    expect(amount.isValid, isFalse);
    expect(amount.value, 1.0);
  });

  test('Should be invalid when set _mustBeGreaterThanZero true and send negative value', () {
    Amount amount = Amount(-1, mustBeGreaterThanZero: true);
    expect(amount.isValid, isFalse);
  });

  test('Should be valid when set _mustBeGreaterThanZero true and send positive value', () {
    Amount amount = Amount(1, mustBeGreaterThanZero: true);
    expect(amount.isValid, isTrue);
  });
}
