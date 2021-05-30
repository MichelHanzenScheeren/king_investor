import 'package:king_investor/shared/notifications/contract.dart';
import 'package:king_investor/shared/value_objects/value_object.dart';

class Email extends ValueObject {
  late String _address;

  Email(String? address) {
    _applyContracts(address);
    _address = address ?? '';
  }

  String get address => _address;

  void setAddress(String? address) {
    clearNotifications();
    _applyContracts(address);
    if (isValid) _address = address!;
  }

  void _applyContracts(String? address) {
    addNotifications(
      Contract()
          .requires()
          .isNotNullOrEmpty(address, 'Email.address', 'O e-mail não pode ser vazio')
          .isValidEmail(address, 'Email.address', 'o e-mail informado não é válido'),
    );
  }
}
