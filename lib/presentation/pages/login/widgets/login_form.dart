import 'package:flutter/material.dart';
import 'package:king_investor/presentation/controllers/login_controller.dart';
import 'package:king_investor/presentation/widgets/custom_button_widget.dart';
import 'package:king_investor/presentation/widgets/custom_text_field_widget.dart';

class LoginForm extends StatelessWidget {
  final double size;
  final LoginController controller;

  LoginForm({@required this.controller, @required this.size});
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextFieldWidget(
            placeHolder: "E-mail",
            prefixIcon: Icon(Icons.alternate_email),
            textInputType: TextInputType.emailAddress,
            enabled: !controller.loading,
            onChanged: (value) {},
          ),
          SizedBox(height: size * 0.05),
          CustomTextFieldWidget(
            placeHolder: "Senha",
            prefixIcon: Icon(Icons.lock_outline),
            textInputType: controller.showPassword ? TextInputType.visiblePassword : TextInputType.text,
            enablePasteOption: false,
            enabled: !controller.loading,
            obscure: !controller.showPassword,
            onChanged: (value) {},
            suffixIcon: Icon(Icons.visibility),
          ),
          SizedBox(height: size * 0.1),
          CustomButtonWidget(
            buttonText: "ENTRAR",
            textStyle: TextStyle(fontSize: 20, color: Theme.of(context).hintColor, fontWeight: FontWeight.bold),
            onPressed: () {},
            backGroundColor: Theme.of(context).accentColor,
          ),
        ],
      ),
    );
  }
}
