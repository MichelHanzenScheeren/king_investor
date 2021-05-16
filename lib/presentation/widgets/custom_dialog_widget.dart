import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/widgets/custom_button_widget.dart';

class CustomDialogWidget extends StatelessWidget {
  final String title;
  final String textContent;
  final String confirmButtonText;
  final Function onConfirm;
  final Color accentColor;

  CustomDialogWidget({this.onConfirm, this.title, this.textContent, this.confirmButtonText, this.accentColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      elevation: 0,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        title ?? '',
        style: TextStyle(color: theme.hintColor, fontSize: 22, fontWeight: FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            textContent ?? '',
            style: TextStyle(color: theme.errorColor, fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(15),
      actionsPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
