import 'package:flutter/material.dart';

class CustomCardWidget extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Axis direction;

  CustomCardWidget({this.children, this.margin, this.padding, this.direction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? const EdgeInsets.fromLTRB(8, 12, 8, 4),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(14),
        child: Flex(
          direction: direction ?? Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: children ?? [],
        ),
      ),
    );
  }
}
