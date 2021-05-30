import 'package:flutter/material.dart';

class OptionRow extends StatelessWidget {
  final IconData leftIcon;
  final Color? itemsColor;
  final String? text;
  final bool showRrightIcon;
  final Function? function;

  OptionRow({
    required this.leftIcon,
    this.itemsColor,
    this.text,
    this.showRrightIcon: true,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = TextStyle(color: itemsColor ?? theme.hintColor, fontSize: 16, fontWeight: FontWeight.w500);
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(leftIcon, color: itemsColor ?? theme.hintColor, size: 30),
            SizedBox(width: 10),
            Expanded(child: Text(text ?? "", style: textStyle)),
            _rightIcon(textStyle),
          ],
        ),
      ),
      onTap: function as void Function()?,
    );
  }

  Widget _rightIcon(TextStyle style) {
    if (!showRrightIcon) return Container();
    return Icon(Icons.edit, color: itemsColor ?? style.color, size: 25);
  }
}
