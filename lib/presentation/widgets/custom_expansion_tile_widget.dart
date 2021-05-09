import 'package:flutter/material.dart';

class CustomExpansionTileWidget extends StatelessWidget {
  final Widget title;
  final List<Widget> children;

  CustomExpansionTileWidget({this.title, this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: theme.cardColor,
      ),
      child: Theme(
        data: theme.copyWith(
          unselectedWidgetColor: theme.primaryColorLight,
          textTheme: TextTheme(subtitle1: TextStyle(fontSize: 20, color: theme.primaryColorLight)),
          accentColor: theme.hintColor,
        ),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          childrenPadding: EdgeInsets.zero,
          title: title ?? Text(''),
          children: children ?? [Container()],
        ),
      ),
    );
  }
}
