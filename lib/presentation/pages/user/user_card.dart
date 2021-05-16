import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';

class UserCard extends StatelessWidget {
  final DateTime createdAt;

  UserCard(this.createdAt);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomCardWidget(
      children: [
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: theme.primaryColorDark,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person, size: 200),
        ),
        SizedBox(height: 12),
        Text(
          "Logado com email e senha.",
          style: TextStyle(color: theme.hintColor, fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          getDataText(),
          style: TextStyle(color: theme.hintColor, fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
      ],
    );
  }

  String getDataText() {
    if (createdAt == null) return "";
    var model = DateFormat("dd/MM/yyyy");
    return "Usuário desde ${model.format(createdAt)}.";
  }
}
