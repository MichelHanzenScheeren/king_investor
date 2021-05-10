import 'package:flutter/material.dart';

class CustomDropdownWidget<T> extends StatelessWidget {
  final dynamic initialValue;
  final Function(T) onChanged;
  final List<DropdownMenuItem<T>> values;
  final IconData icon;
  final bool isDense;
  final bool hasUnderline;
  final bool isFilled;

  CustomDropdownWidget({
    @required this.initialValue,
    this.values,
    this.onChanged,
    this.icon: Icons.filter_list,
    this.isDense: true,
    this.hasUnderline: false,
    this.isFilled: true,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<T>(
        dropdownColor: isFilled ? Colors.grey[200] : theme.dialogBackgroundColor,
        icon: Icon(icon, color: isFilled ? Colors.black : theme.hintColor),
        iconSize: 25,
        elevation: 5,
        value: initialValue,
        isExpanded: true,
        isDense: isDense,
        style: TextStyle(color: Colors.white),
        underline: hasUnderline
            ? Container(
                height: 2,
                color: Colors.grey[700],
                margin: EdgeInsets.only(top: 40),
              )
            : Container(),
        onChanged: onChanged,
        items: values,
      ),
    );
  }
}
