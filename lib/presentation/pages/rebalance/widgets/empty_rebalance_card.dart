import 'package:flutter/material.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';

class EmptyRebalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = TextStyle(color: Theme.of(context).hintColor, fontSize: 22);
    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: CustomCardWidget(
        children: [
          SizedBox(height: 22),
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
              '* Personalizado pelo valor do aporte;\n* Limitar nº de ativos e categorias;\n* Salvar resultados...',
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
