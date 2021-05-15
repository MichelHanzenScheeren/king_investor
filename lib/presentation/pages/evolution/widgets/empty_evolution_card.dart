import 'package:flutter/material.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';

class EmptyEvolutionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = TextStyle(color: Theme.of(context).hintColor, fontSize: 23);
    return CustomCardWidget(
      children: [
        SizedBox(height: 25),
        Text(
          "Quando cadastrar ativos, poderá acompanhar aqui a sua evolução...",
          style: textTheme,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Icon(
          Icons.show_chart,
          size: 180,
        ),
        SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.bottomLeft,
          child: Text(
            "* Total em carteira;\n* Total Investido;\n* Proventos e vendas;\n* Valorização...",
            style: textTheme.copyWith(fontSize: 20, height: 1.5),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(height: 25),
      ],
    );
  }
}
