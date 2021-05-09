import 'package:flutter/material.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';

class EmptyAssets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = TextStyle(color: Theme.of(context).primaryColorLight, fontSize: 25);
    return CustomCardWidget(
      children: [
        SizedBox(height: 10),
        Text(
          "Poxa, parece que sua carteira está vazia!",
          style: textTheme,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Icon(
          Icons.add_shopping_cart_sharp,
          size: 180,
        ),
        SizedBox(height: 20),
        Text(
          "Sem pânico: comece a cadastrar seus ativos agora mesmo...",
          style: textTheme,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
        Transform.rotate(
          angle: -0.7,
          child: Icon(
            Icons.arrow_downward,
            size: 50,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
