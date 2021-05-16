import 'package:flutter/material.dart';

class CustomExpansionTileWidget extends StatelessWidget {
  final Widget title;
  final List<Widget> children;
  final EdgeInsets margin;
  final EdgeInsets childrenPadding;
  final bool initiallyExpanded;

  CustomExpansionTileWidget({
    this.title,
    this.children,
    this.margin,
    this.childrenPadding,
    this.initiallyExpanded: false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: margin ?? const EdgeInsets.all(8),
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
          initiallyExpanded: initiallyExpanded,
          maintainState: true,
          tilePadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          childrenPadding: childrenPadding ?? EdgeInsets.zero,
          title: title ?? Text(''),
          children: children ?? [Container()],
        ),
      ),
    );
  }
}
