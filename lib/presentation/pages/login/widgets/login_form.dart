import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:king_investor/presentation/controllers/login_controller.dart';
import 'package:king_investor/presentation/widgets/custom_button_widget.dart';
import 'package:king_investor/presentation/widgets/custom_text_field_widget.dart';
import 'package:king_investor/presentation/widgets/load_indicator_widget.dart';

class LoginForm extends StatelessWidget {
  final double size;
  final LoginController controller;

  LoginForm({@required this.controller, @required this.size});
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              Obx(() {
                return CustomTextFieldWidget(
                  placeHolder: "E-mail",
                  prefixIcon: Icon(Icons.alternate_email),
                  textInputType: TextInputType.emailAddress,
                  enabled: !controller.loading,
                  onChanged: controller.setEmail,
                  validator: controller.emailValidator,
                );
              }),
              SizedBox(height: size * 0.05),
              Obx(() {
                return CustomTextFieldWidget(
                  placeHolder: "Senha",
                  prefixIcon: Icon(Icons.lock_outline),
                  textInputType: controller.showPassword ? TextInputType.visiblePassword : TextInputType.text,
                  enablePasteOption: false,
                  enabled: !controller.loading,
                  obscure: !controller.showPassword,
                  onChanged: controller.setPassword,
                  validator: controller.passwordValidator,
                  suffixIcon: IconButton(
                    onPressed: controller.setShowPassword,
                    icon: Icon(controller.showPassword ? Icons.visibility : Icons.visibility_off),
                  ),
                );
              }),
              SizedBox(height: size * 0.1),
              Obx(() {
                if (controller.loading) return Container(child: LoadIndicatorWidget());
                return CustomButtonWidget(
                  buttonText: "INICIAR SESSÃO",
                  textStyle: TextStyle(fontSize: 18, color: Theme.of(context).hintColor, fontWeight: FontWeight.bold),
                  backGroundColor: Theme.of(context).accentColor,
                  onPressed: () {
                    if (!Form.of(context).validate()) {
                      print('INVÁLIDO!');
                      return;
                    }
                    FocusScope.of(context).requestFocus(new FocusNode());
                    controller.doLogin();
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
