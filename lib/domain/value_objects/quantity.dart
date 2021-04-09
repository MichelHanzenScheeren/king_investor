import 'package:king_investor/shared/notifications/contract.dart';
import 'package:king_investor/shared/value_objects/value_object.dart';

class Quantity extends ValueObject {
  int _value;

  Quantity(int value) {
    _applyContracts(value);
    _value = isValid ? value : 0;
  }

  int get value => _value;

  void setValue(int value) {
    clearNotifications();
    _applyContracts(value);
    if (isValid) _value = value;
  }

  void _applyContracts(int value) {
    addNotifications(
      Contract()
          .requires()
          .isNotNull(value, 'Quantity.value', 'A quantidade não pode ser nula')
          .isGreatherOrEqualTo(value, 0, 'Quantity.value', 'A quantidade precisa ser um número maior ou igual a zero'),
    );
  }
}
