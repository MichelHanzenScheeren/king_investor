import 'package:king_investor/shared/notifications/contract.dart';
import 'package:king_investor/shared/value_objects/value_object.dart';

class Password extends ValueObject {
  String _value;
  Password(String value) {
    _value = value;
    _applyContracts();
  }

  void _applyContracts() {
    addNotifications(
      Contract()
          .requires()
          .isNotNullOrEmpty(_value, 'Password.value', 'A senha não pode ser vazia')
          .minAndMaxLength(_value, 8, 50, 'Password.value', 'A senha precisa ter entre 8 e 50 caracteres'),
    );
  }
}
