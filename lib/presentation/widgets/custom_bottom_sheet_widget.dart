import 'package:flutter/material.dart';

class CustomBottomSheetWidget extends StatelessWidget {
  final List<Widget> children;
  final List<CustomBottomSheetOption> options;

  CustomBottomSheetWidget({this.children, this.options});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: theme.primaryColorDark,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children ?? (options ?? [Container()]),
        ),
      ),
    );
  }
}

class CustomBottomSheetOption extends StatelessWidget {
  final String text;
  final double textSize;
  final IconData icon;
  final bool show;
  final Function onTap;

  CustomBottomSheetOption({this.text, this.textSize, this.icon, this.show, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if ((show ?? true) == false) return Container();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            icon == null ? Container() : Icon(icon, size: 30, color: theme.hintColor),
            icon == null ? Container() : SizedBox(width: 20),
            Flexible(
              child: Text(
                text ?? '',
                style: TextStyle(fontSize: textSize ?? 22, color: theme.hintColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
