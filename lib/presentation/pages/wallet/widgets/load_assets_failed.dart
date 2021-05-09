import 'package:flutter/material.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';

class LoadAssetsFailed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = TextStyle(color: Theme.of(context).primaryColorLight, fontSize: 25);
    return CustomCardWidget(
      children: [
        SizedBox(height: 10),
        Icon(
          Icons.error_outline_rounded,
          size: 180,
        ),
        SizedBox(height: 20),
        Text(
          'Poxa, tivemos um probleminha para carregar seus ativos',
          style: textTheme,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Text(
          'Tente novamente mais tarde...',
          style: textTheme,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
