import 'package:flutter/material.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';

class EmptyERebalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = TextStyle(color: Theme.of(context).hintColor, fontSize: 22);
    return CustomCardWidget(
      children: [
        SizedBox(height: 25),
        Text(
          'Quando cadastrar ativos, verá aqui sugestões de rebalanceamento...',
          style: textTheme,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Icon(
          Icons.account_balance,
          size: 180,
        ),
        SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.bottomLeft,
          child: Text(
            '* Personalizado pelo valor do aporte;\n* Possibilidade de limitar nº ativos;\n' +
                '* Possibilidade de limitar nº categorias;\n* Salvar resultados...',
            style: textTheme.copyWith(fontSize: 18, height: 1.5),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(height: 25),
      ],
    );
  }
}
