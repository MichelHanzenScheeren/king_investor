import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/widgets/custom_button_widget.dart';

class CustomDialogWidget extends StatelessWidget {
  final String title;
  final String textContent;
  final String confirmButtonText;
  final Function onConfirm;
  final Color accentColor;
  final Color textContentColor;

  CustomDialogWidget({
    this.onConfirm,
    this.title,
    this.textContent,
    this.confirmButtonText,
    this.accentColor,
    this.textContentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      elevation: 0,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        title ?? '',
        style: TextStyle(color: theme.hintColor, fontSize: 24, fontWeight: FontWeight.w800),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            textContent ?? '',
            style: TextStyle(color: textContentColor ?? theme.errorColor, fontSize: 18, fontWeight: FontWeight.w800),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      insetPadding: const EdgeInsets.all(25),
      actionsPadding: EdgeInsets.fromLTRB(20, 10, 20, 15),
      actions: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButtonWidget(
              buttonText: 'CANCELAR',
              textStyle: TextStyle(color: theme.primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
              backGroundColor: Colors.grey[900],
              borderColor: theme.primaryColor,
              width: 125,
              onPressed: () => Get.back(),
            ),
            CustomButtonWidget(
              buttonText: confirmButtonText ?? '',
              textStyle: TextStyle(color: theme.hintColor, fontSize: 18, fontWeight: FontWeight.bold),
              backGroundColor: accentColor ?? theme.errorColor,
              borderColor: Colors.transparent,
              onPressed: onConfirm,
              width: 125,
            ),
          ],
        ),
      ],
    );
  }
}
