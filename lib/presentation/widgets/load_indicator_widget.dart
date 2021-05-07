import 'package:flutter/material.dart';

class LoadIndicatorWidget extends StatelessWidget {
  final Color color;
  LoadIndicatorWidget({this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color ?? Theme.of(context).accentColor),
          strokeWidth: 5,
        ),
      ),
    );
  }
}
