import 'package:king_investor/shared/notifications/contract.dart';
import 'package:king_investor/shared/value_objects/value_object.dart';

class Score extends ValueObject {
  late int _value;

  Score(int? value) {
    _applyContracts(value);
    _value = isValid ? value! : 0;
  }

  int get value => _value;

  void setValue(int? value) {
    clearNotifications();
    _applyContracts(value);
    if (isValid) _value = value!;
  }

  void setValueFromString(String value) {
    clearNotifications();
    _applyStringContracts(value);
    if (isValid) _value = int.parse(value);
  }

  void _applyContracts(int? value) {
    addNotifications(
      Contract()
          .requires()
          .isNotNull(value, 'Score.value', 'A nota não pode ser nula')
          .isGreatherOrEqualTo(value, 0, 'Score.value', 'A nota precisa ser um número natural maior ou igual a zero'),
    );
  }

  void _applyStringContracts(String value) {
    addNotifications(
      Contract()
          .requires()
          .isNotNull(value, 'Score.value', 'O número não pode ser nulo')
          .canBeConvertedToInt(value, 'Score.value', 'A nota deve ser um número inteiro')
          .isGreatherOrEqualTo(int.tryParse(value), 0, 'Score.value', 'A nota deve ser maior ou igual a zero'),
    );
  }
}
