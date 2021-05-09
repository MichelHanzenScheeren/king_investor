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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: margin ?? const EdgeInsets.all(8),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
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
