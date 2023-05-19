import 'package:king_investor/shared/notifications/contract.dart';
import 'package:king_investor/shared/value_objects/value_object.dart';

class Amount extends ValueObject {
  double _value;
  bool _mustBeGreaterThanZero;

  Amount(double value, {mustBeGreaterThanZero = false}) {
    _mustBeGreaterThanZero = mustBeGreaterThanZero ?? false;
    _applyDoubleContracts(value);
    _value = isValid ? value : (_mustBeGreaterThanZero ? 1.0 : 0.0);
  }

  Amount.fromString(String value, {mustBeGreaterThanZero = false}) {
    _mustBeGreaterThanZero = mustBeGreaterThanZero ?? false;
    if (value != null) value = value.replaceAll(',', '.');
    _applyStringContracts(value);
    _value =
        isValid ? double.parse(value) : (_mustBeGreaterThanZero ? 1.0 : 0.0);
  }

  double get value => _value;

  void setValue(double value) {
    clearNotifications();
    _applyDoubleContracts(value);
    if (isValid) _value = value;
  }

  void setValueFromString(String value) {
    if (value != null) value = value.replaceAll(',', '.');
    clearNotifications();
    _applyStringContracts(value);
    if (isValid) _value = double.parse(value);
  }

  void _applyDoubleContracts(double value) {
    addNotifications(Contract()
        .isNotNull(value, 'Amount.value', 'O valor não pode ser nulo'));
    if (_mustBeGreaterThanZero)
      addNotifications(Contract().isGreatherThan(
          value, 0, 'Amount.value', 'O valor precisa ser maior do que zero'));
  }

  void _applyStringContracts(String value) {
    addNotifications(
      Contract()
          .requires()
          .isNotNull(value, 'Amount.value', 'O número não pode ser nulo')
          .canBeConvertedToDouble(
              value, 'Amount.value', 'Valor numérico inválido'),
    );
    if (_mustBeGreaterThanZero) {
      double newValue = double.tryParse(value);
      addNotifications(Contract().isGreatherThan(
          newValue, 0, 'Amount.value', 'O valor deve ser maior do que zero'));
    }
  }

  String toMonetary(String currency) {
    String monetary = _value.toStringAsFixed(2).replaceAll('.', ',');
    if (currency == 'BRL') return 'R\$ ' + monetary;
    if (currency == 'USD') return '\$ ' + monetary;
    return currency + ' ' + monetary;
  }

  String toPorcentage() => _value.toStringAsFixed(2).replaceAll('.', ',') + '%';
}
