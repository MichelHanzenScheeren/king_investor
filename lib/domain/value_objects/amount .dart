import 'package:king_investor/shared/notifications/contract.dart';
import 'package:king_investor/shared/value_objects/value_object.dart';

class Amount extends ValueObject {
  double _value;

  Amount(double value) {
    _applyDoubleContracts(value);
    _value = isValid ? value : 0.0;
  }

  Amount.fromString(String value) {
    if (value != null) value = value.replaceAll(',', '.');
    _applyStringContracts(value);
    _value = isValid ? double.parse(value) : 0.0;
  }

  double get value => _value;

  void setValue(double value) {
    clearNotifications();
    _applyDoubleContracts(value);
    if (isValid) _value = value;
  }

  void setValueFromString(String value) {
    clearNotifications();
    _applyStringContracts(value);
    if (isValid) _value = double.parse(value);
  }

  void _applyDoubleContracts(double value) {
    addNotifications(Contract().requires().isNotNull(value, 'Amount.value', 'O número não pode ser nulo'));
  }

  void _applyStringContracts(String value) {
    addNotifications(
      Contract()
          .requires()
          .isNotNull(value, 'Amount.value', 'O número não pode ser nulo')
          .canBeConvertedToDouble(value, 'Amount.value', 'Valor numérico inválido'),
    );
  }

  String toMonetary(String currency) {
    String monetary = _value.toStringAsFixed(2).replaceAll('.', ',');
    if (currency == 'BRL') return 'R\$ ' + monetary;
    if (currency == 'USD') return '\$ ' + monetary;
    return currency + ' ' + monetary;
  }

  String toPorcentage() => _value.toStringAsFixed(2).replaceAll('.', ',') + '%';
}
