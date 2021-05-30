import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/value_objects/email.dart';
import 'package:king_investor/domain/value_objects/name.dart';
import 'package:king_investor/presentation/controllers/user_controller.dart';
import 'package:king_investor/presentation/pages/user/widgets/user_card.dart';
import 'package:king_investor/presentation/pages/user/widgets/options_row.dart';
import 'package:king_investor/presentation/pages/user/widgets/update_user_data.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/custom_dialog_widget.dart';
import 'package:king_investor/presentation/widgets/load_card_widget.dart';

class UserPage extends StatelessWidget {
  final userControler = UserController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('KING INVESTOR', style: TextStyle(color: theme.hintColor)),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          GetX<UserController>(
            init: userControler,
            builder: (userController) {
              if (userControler.userLoad) return LoadCardWidget();
              // if (!userControler.validUSer) return InvalidUserCard();
              final user = userControler.user!;
              return Column(
                children: [
                  SizedBox(height: 4),
                  UserCard(user.createdAt),
                  CustomCardWidget(
                    children: [
                      OptionRow(
                        leftIcon: Icons.person,
                        text: user.name.firstName,
                        function: () => _updateName(userControler),
                      ),
                      OptionRow(
                        leftIcon: Icons.person_add_alt,
                        text: user.name.lastName,
                        function: () => _updateLastName(userControler),
                      ),
                      OptionRow(
                        leftIcon: Icons.alternate_email,
                        text: user.email.address,
                        function: () => _updateEmail(userControler),
                      ),
                      OptionRow(
                        leftIcon: Icons.lock_outline,
                        text: "************",
                        function: () => _passwordReset(userControler),
                      ),
                      OptionRow(
                        leftIcon: Icons.exit_to_app,
                        itemsColor: theme.errorColor,
                        text: "Sair da conta.",
                        showRrightIcon: false,
                        function: () => _doLogout(userControler),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _updateName(UserController userControler) {
    final userName = userControler.user?.name;
    final Name auxName = Name(userName?.firstName, userName?.lastName);
    Get.bottomSheet(UpdateUserData(
      value: auxName.firstName,
      prefixText: 'Nome',
      onChange: (firstName) => auxName.setName(firstName, 'Auxiliar'),
      validate: (value) => auxName.isValid ? null : auxName.firstNotification,
      onSubmit: () {
        userName!.setName(auxName.firstName, userName.lastName);
        userControler.updateUserData();
      },
    ));
  }

  void _updateLastName(UserController userControler) {
    final userName = userControler.user!.name;
    final Name auxLastName = Name(userName.firstName, userName.lastName);
    Get.bottomSheet(UpdateUserData(
      value: auxLastName.lastName,
      prefixText: 'Sobrenome',
      onChange: (lastName) => auxLastName.setName(userName.firstName, lastName),
      validate: (value) => auxLastName.isValid ? null : auxLastName.firstNotification,
      onSubmit: () {
        userName.setName(userName.firstName, auxLastName.lastName);
        userControler.updateUserData();
      },
    ));
  }

  void _updateEmail(UserController userControler) {
    final Email auxEmail = Email(userControler.user!.email.address);
    Get.bottomSheet(UpdateUserData(
      value: auxEmail.address,
      prefixText: 'E-mail',
      onChange: (email) => auxEmail.setAddress(email),
      validate: (value) => auxEmail.isValid ? null : auxEmail.firstNotification,
      onSubmit: () {
        userControler.user!.email.setAddress(auxEmail.address);
        userControler.updateUserData();
      },
    ));
  }

  void _passwordReset(UserController userControler) {
    Get.dialog(CustomDialogWidget(
      title: 'Tem certeza que deseja alterar sua senha?',
      textContent: 'Uma mensagem com as instruções de redefinição será enviada ao seu e-mail.',
      accentColor: Theme.of(Get.context!).primaryColor,
      textContentColor: Theme.of(Get.context!).hintColor,
      confirmButtonText: 'REDEFINIR',
      onConfirm: userControler.passwordReset,
    ));
  }

  void _doLogout(UserController userControler) {
    Get.dialog(CustomDialogWidget(
      title: 'Tem certeza que deseja fazer o logout?',
      confirmButtonText: 'SAIR',
      onConfirm: userControler.doLogout,
    ));
  }
}
