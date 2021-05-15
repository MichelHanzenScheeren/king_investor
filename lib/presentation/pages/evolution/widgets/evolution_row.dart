import 'package:flutter/material.dart';

class EvolutionRow extends StatelessWidget {
  final String title;
  final String value;
  final bool color;
  final String complement;
  final double factor;

  EvolutionRow(this.title, this.value, {this.color: false, this.complement: '', this.factor: 1.0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final commonStyle = TextStyle(color: theme.hintColor, fontSize: 16 * factor, fontWeight: FontWeight.w600);
    final greaterStyle = TextStyle(color: theme.hintColor, fontSize: 18 * factor, fontWeight: FontWeight.w800);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(title, style: complement.isEmpty ? commonStyle : greaterStyle)),
            Flexible(
              child: complement.isEmpty
                  ? Text(value, style: color ? _coloredStyle(commonStyle) : commonStyle)
                  : RichText(
                      text: TextSpan(
                        text: value,
                        style: _coloredStyle(greaterStyle),
                        children: [
                          TextSpan(text: ' ($complement)', style: _coloredStyle(greaterStyle.copyWith(fontSize: 13))),
                        ],
                      ),
                    ),
            ),
          ],
        ),
        SizedBox(height: 6),
      ],
    );
  }

  TextStyle _coloredStyle(TextStyle style) {
    String auxValue = value.replaceAll(' ', '').replaceAll('R\$', '').replaceAll(',', '').replaceAll('%', '');
    auxValue.replaceAll('(', '').replaceAll(')', '');
    if (double.tryParse(auxValue) == null) return style;
    if (double.parse(auxValue) > 0) return style.copyWith(color: Colors.green[300].withAlpha(240));
    if (double.parse(auxValue) < 0) return style.copyWith(color: Colors.red[400].withAlpha(220));
    return style;
  }
}
