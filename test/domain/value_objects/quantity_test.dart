import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';

main() {
  test('Should be invalid when value is null', () {
    Quantity quantity = Quantity(null);
    expect(quantity.isValid, isFalse);
    expect(quantity.value, 1);
  });

  test('Should be invalid when value is lower than 1', () {
    Quantity quantity = Quantity(0);
    expect(quantity.isValid, isFalse);
    expect(quantity.value, 1);
  });

  test('Should be valid when value is a valid int', () {
    Quantity quantity = Quantity(1);
    expect(quantity.isValid, isTrue);
    expect(quantity.value, 1);
  });

  test('Should be invalid when try set with invalid int', () {
    Quantity quantity = Quantity(2);
    quantity.setValue(null);
    expect(quantity.isValid, isFalse);
    expect(quantity.value, 2);
  });

  test('Should be valid when try set with valid int', () {
    Quantity quantity = Quantity(2);
    quantity.setValue(5);
    expect(quantity.isValid, isTrue);
    expect(quantity.value, 5);
  });
}
