import 'package:king_investor/shared/notifications/contract.dart';
import 'package:king_investor/shared/value_objects/value_object.dart';

class Quantity extends ValueObject {
  int _value;

  Quantity(int value) {
    _applyContracts(value);
    _value = isValid ? value : 1;
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
    addNotifications(
      Contract()
          .requires()
          .isNotNull(value, 'Quantity.value', 'A quantidade não pode ser nula')
          .isGreatherThan(value, 0, 'Quantity.value', 'A quantidade precisa ser maior do que zero'),
    );
  }

  void _applyStringContracts(String value) {
    addNotifications(
      Contract()
          .requires()
          .isNotNull(value, 'Quantity.value', 'O número não pode ser nulo')
          .canBeConvertedToInt(value, 'Quantity.value', 'A quantidade precisa ser um número inteiro')
          .isGreatherThan(int.tryParse(value), 0, 'Quantity.value', 'A quantidade precisa ser maior do que zero'),
    );
  }
}
