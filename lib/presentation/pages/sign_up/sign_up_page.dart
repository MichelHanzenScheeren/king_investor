import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:king_investor/presentation/controllers/sign_up_controller.dart';
import 'package:king_investor/presentation/pages/sign_up/widgets/sign_up_form.dart';
import 'package:king_investor/presentation/static/app_images.dart';

class SignUpPage extends StatelessWidget {
  final controller = SignUpController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final double size = (screenSize.width < screenSize.height ? screenSize.width : screenSize.height);
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: size * 0.08, vertical: size * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
                      width: size * 0.3,
                      child: Image(image: AssetImage(AppImages.transparentLogo), fit: BoxFit.fill),
                    ),
                  ),
                  SizedBox(height: size * 0.08),
                  SignUpForm(controller: controller, size: size),
                  SizedBox(height: size * 0.1),
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Já possui uma conta?',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: theme.hintColor, fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: controller.goToLoginPage,
                  ),
                  GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.only(top: 2),
                      alignment: Alignment.center,
                      child: Text(
                        'ENTRAR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.hintColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    onTap: controller.goToLoginPage,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
