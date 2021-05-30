import 'package:king_investor/shared/notifications/contract.dart';
import 'package:king_investor/shared/value_objects/value_object.dart';

class Name extends ValueObject {
  late String _firstName;
  late String _lastName;

  Name(String? firstName, String? lastName) {
    _applyContracts(firstName, lastName);
    _firstName = firstName ?? '';
    _lastName = lastName ?? '';
  }

  String get firstName => _firstName;
  String get lastName => _lastName;

  @override
  String toString() => _firstName + ' ' + _lastName;

  void setName(String? firstName, String? lastName) {
    clearNotifications();
    _applyContracts(firstName, lastName);
    if (isValid) {
      _firstName = firstName!;
      _lastName = lastName!;
    }
  }

  void _applyContracts(String? firstName, String? lastName) {
    addNotifications(
      Contract()
          .requires()
          .isNotNull(firstName, 'Name.firstName', 'O primeiro nome não pode ser nulo ou vazio')
          .minAndMaxLength(firstName, 3, 30, 'Name.firstName', 'O primeiro nome precisa ter entre 3 e 30 caracteres')
          .isNotNull(lastName, 'Name.lastName', 'O sobrenome não pode ser nulo ou vazio')
          .minAndMaxLength(lastName, 3, 50, 'Name.lastName', 'O sobrenome precisa ter entre 3 e 50 caracteres'),
    );
  }
}
