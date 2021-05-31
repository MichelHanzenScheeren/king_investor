import 'package:flutter/material.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';

class EmptyDistributionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = TextStyle(color: Theme.of(context).hintColor, fontSize: 23);
    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: CustomCardWidget(
        children: [
          SizedBox(height: 22),
          Text(
            "Quando cadastrar ativos, verá aqui gráficos da distribuição...",
            style: textTheme,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Icon(
            Icons.pie_chart,
            size: 180,
          ),
          SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.bottomLeft,
            child: Text(
              "* Distribuição geral das categorias;\n* Distribuição de cada categoria;\n* Distriuição geral dos ativos...",
              style: textTheme.copyWith(fontSize: 20, height: 1.5),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
