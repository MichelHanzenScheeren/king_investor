import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:king_investor/presentation/controllers/login_controller.dart';
import 'package:king_investor/presentation/pages/login/widgets/login_form.dart';
import 'package:king_investor/presentation/static/app_images.dart';

class LoginPage extends StatelessWidget {
  final controller = LoginController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double size = (screenSize.width < screenSize.height ? screenSize.width : screenSize.height);
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: size * 0.08),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
                        width: size * 0.3,
                        child: Image(image: AssetImage(AppImages.transparentLogo), fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(height: size * 0.1),
                    LoginForm(controller: controller, size: size),
                    SizedBox(height: size * 0.1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
