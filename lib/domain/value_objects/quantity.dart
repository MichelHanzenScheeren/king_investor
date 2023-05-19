import 'package:king_investor/shared/notifications/contract.dart';
import 'package:king_investor/shared/value_objects/value_object.dart';

class Quantity extends ValueObject {
  int _value;
  bool _mustBeGreaterThanZero;

  Quantity(int value, {mustBeGreaterThanZero = false}) {
    _mustBeGreaterThanZero = mustBeGreaterThanZero ?? false;
    _applyContracts(value);
    _value = isValid ? value : (mustBeGreaterThanZero ? 1 : 0);
  }

  int get value => _value;

  void setValue(int value) {
    clearNotifications();
    _applyContracts(value);
    if (isValid) _value = value;
  }

  void setValueFromString(String value) {
    clearNotifications();
    _applyStringContracts(value);
    if (isValid) _value = int.parse(value);
  }

  void _applyContracts(int value) {
    if (_mustBeGreaterThanZero) {
      addNotifications(
        Contract()
            .isNotNull(
                value, 'Quantity.value', 'A quantidade não pode ser nula')
            .isGreatherThan(value, 0, 'Quantity.value',
                'A quantidade precisa ser maior do que zero'),
      );
    } else {
      addNotifications(
        Contract()
            .isNotNull(
                value, 'Quantity.value', 'A quantidade não pode ser nula')
            .isGreatherOrEqualTo(value, 0, 'Quantity.value',
                'A quantidade precisa ser maior ou igual a zero'),
      );
    }
  }

  void _applyStringContracts(String value) {
    addNotifications(
      Contract()
          .requires()
          .isNotNull(value, 'Quantity.value', 'O número não pode ser nulo')
          .canBeConvertedToInt(value, 'Quantity.value',
              'A quantidade precisa ser um número inteiro')
          .isGreatherThan(int.tryParse(value), 0, 'Quantity.value',
              'A quantidade precisa ser maior do que zero'),
    );
  }
}
