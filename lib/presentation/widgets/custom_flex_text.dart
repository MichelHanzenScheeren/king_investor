import 'package:flutter/material.dart';

class CustomFlexText extends StatelessWidget {
  final MainAxisAlignment alignment;
  final List<String> texts;
  final TextStyle style;
  final FontWeight weight;
  final double size;
  final Color color;
  final bool strong;
  final bool showDivider;

  CustomFlexText({
    this.alignment: MainAxisAlignment.center,
    this.texts: const <String>[],
    this.style,
    this.weight: FontWeight.w500,
    this.size: 17,
    this.color,
    this.strong: true,
    this.showDivider: true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final light = theme.primaryColorLight;
    final hint = theme.hintColor;
    final aux = style ?? TextStyle(fontWeight: weight, fontSize: size, color: color ?? (strong ? hint : light));
    return Column(
      children: [
        Row(
          mainAxisAlignment: alignment,
          children: texts.map((text) {
            return Container(
              child: Flexible(
                child: Text(text ?? '!', style: aux),
              ),
            );
          }).toList(),
        ),
        showDivider ? Divider(color: theme.primaryColorLight.withAlpha(50), height: 10) : Container(),
        SizedBox(height: 2),
      ],
    );
  }
}
