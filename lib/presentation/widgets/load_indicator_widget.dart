import 'package:flutter/material.dart';

class LoadIndicatorWidget extends StatelessWidget {
  final Color? color;
  final double? size;
  final double? strokeWidth;
  final bool usePrimaryColor;

  LoadIndicatorWidget({this.color, this.size, this.strokeWidth, this.usePrimaryColor: true});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: size ?? 50,
        width: size ?? 50,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? (usePrimaryColor ? Theme.of(context).primaryColor : Theme.of(context).primaryColorLight),
          ),
          strokeWidth: strokeWidth ?? 5,
        ),
      ),
    );
  }
}
