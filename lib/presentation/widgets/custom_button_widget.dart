import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final Color backGroundColor;
  final Color borderColor;
  final String buttonText;
  final TextStyle textStyle;
  final Function onPressed;
  final double heigth;
  final double width;
  final double borderRadius;
  CustomButtonWidget({
    this.backGroundColor,
    this.borderColor,
    this.buttonText = "",
    this.textStyle,
    this.onPressed,
    this.heigth,
    this.width = double.infinity,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: heigth,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16)),
          elevation: MaterialStateProperty.all(1),
          backgroundColor: MaterialStateProperty.all(
              (backGroundColor ?? theme.primaryColor)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: borderColor ?? theme.primaryColor),
          )),
        ),
        child: Text(
          buttonText,
          style: textStyle ?? theme.textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
