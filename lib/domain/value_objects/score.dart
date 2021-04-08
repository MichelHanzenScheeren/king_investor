import 'package:king_investor/shared/notifications/contract.dart';
import 'package:king_investor/shared/value_objects/value_object.dart';

class Score extends ValueObject {
  int _value;

  Score(int value) {
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
          .isNotNull(value, 'Score.value', 'A nota não pode ser nula')
          .isGreatherOrEqualTo(value, 0, 'Score.value', 'A nota precisa ser um número natural maior ou igual a zero'),
    );
  }
}
