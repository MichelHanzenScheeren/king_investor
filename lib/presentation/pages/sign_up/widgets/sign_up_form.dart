import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/sign_up_controller.dart';
import 'package:king_investor/presentation/widgets/custom_button_widget.dart';
import 'package:king_investor/presentation/widgets/custom_text_field_widget.dart';
import 'package:king_investor/presentation/widgets/load_indicator_widget.dart';

class SignUpForm extends StatelessWidget {
  final SignUpController? controller;
  final double? size;

  SignUpForm({this.controller, this.size});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              Obx(() {
                return CustomTextFieldWidget(
                  placeHolder: "Nome",
                  prefixIcon: Icons.person_pin_outlined,
                  enabled: !controller!.loading,
                  onChanged: controller!.setFirstName,
                  validator: controller!.firstNameValidator,
                );
              }),
              SizedBox(height: size! * 0.04),
              Obx(() {
                return CustomTextFieldWidget(
                  placeHolder: "Sobrenome",
                  prefixIcon: Icons.person_add_alt,
                  enabled: !controller!.loading,
                  onChanged: controller!.setLastName,
                  validator: controller!.lastNameNameValidator,
                );
              }),
              SizedBox(height: size! * 0.04),
              Obx(() {
                return CustomTextFieldWidget(
                  placeHolder: "E-mail",
                  prefixIcon: Icons.alternate_email,
                  textInputType: TextInputType.emailAddress,
                  enabled: !controller!.loading,
                  onChanged: controller!.setEmail,
                  validator: controller!.emailValidator,
                );
              }),
              SizedBox(height: size! * 0.04),
              Obx(() {
                return CustomTextFieldWidget(
                  placeHolder: "Senha",
                  prefixIcon: Icons.lock_outline,
                  textInputType: controller!.showPassword ? TextInputType.visiblePassword : TextInputType.text,
                  enablePasteOption: false,
                  enabled: !controller!.loading,
                  obscure: !controller!.showPassword,
                  onChanged: controller!.setPassword,
                  validator: controller!.passwordValidator,
                  suffixIcon: IconButton(
                    onPressed: controller!.setShowPassword,
                    icon: Icon(controller!.showPassword ? Icons.visibility : Icons.visibility_off),
                  ),
                );
              }),
              SizedBox(height: size! * 0.06),
              Obx(() {
                if (controller!.loading) return Container(child: LoadIndicatorWidget());
                return CustomButtonWidget(
                  buttonText: "CONFIRMAR CADASTRO",
                  textStyle: TextStyle(fontSize: 18, color: Theme.of(context).hintColor, fontWeight: FontWeight.bold),
                  backGroundColor: Theme.of(context).accentColor,
                  onPressed: () {
                    if (!Form.of(context)!.validate()) {
                      return;
                    }
                    FocusScope.of(context).requestFocus(new FocusNode());
                    controller!.doSignUp();
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
