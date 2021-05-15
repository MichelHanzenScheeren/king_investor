import 'package:flutter/material.dart';

class CustomDropdownWidget<T> extends StatelessWidget {
  final T initialValue;
  final Function(T) onChanged;
  final List<CustomDropdownItems<T>> values;

  final IconData icon;
  final bool isDense;
  final bool hasUnderline;
  final bool isFilled;
  final String prefixText;

  CustomDropdownWidget({
    @required this.initialValue,
    @required this.values,
    this.onChanged,
    this.icon: Icons.filter_list,
    this.isDense: true,
    this.hasUnderline: false,
    this.isFilled: true,
    this.prefixText: '',
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<T>(
          dropdownColor: isFilled ? Colors.grey[100] : theme.dialogBackgroundColor,
          icon: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: Icon(icon, color: isFilled ? Colors.black : theme.hintColor),
          ),
          iconSize: 25,
          elevation: 5,
          value: initialValue,
          isExpanded: true,
          style: TextStyle(color: Colors.white),
          onChanged: onChanged,
          underline: Container(),
          selectedItemBuilder: (context) {
            return values.map((item) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.fromLTRB(20, 14, 10, 10),
                child: Text(
                  (prefixText.isNotEmpty ? '$prefixText:  ' : '') + item.text,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              );
            }).toList();
          },
          items: values.map((item) {
            return DropdownMenuItem<T>(
              value: item.value,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Text(item.text, style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            );
          }).toList()),
    );
  }
}

class CustomDropdownItems<T> {
  final T value;
  final String text;

  CustomDropdownItems(this.value, this.text);
}
