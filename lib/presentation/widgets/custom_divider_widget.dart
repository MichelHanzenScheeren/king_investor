import 'package:flutter/material.dart';

class CustomDividerWidget extends StatelessWidget {
  final String? text;
  final Color? textColor;
  final Color? dividerColor;
  final Alignment align;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;

  CustomDividerWidget({
    this.text,
    this.dividerColor,
    this.textColor,
    this.align: Alignment.center,
    this.height: 40,
    this.fontSize: 16,
    this.fontWeight: FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).hintColor;
    final dividerColor = Theme.of(context).primaryColorLight;
    return Row(
      children: <Widget>[
        align != Alignment.centerLeft ? Expanded(child: Divider(color: dividerColor, height: height)) : Container(),
        SizedBox(width: 5),
        Text(text ?? '', style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: fontWeight)),
        SizedBox(width: 5),
        align != Alignment.centerRight ? Expanded(child: Divider(color: dividerColor, height: height)) : Container(),
      ],
    );
  }
}
