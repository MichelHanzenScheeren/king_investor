import 'package:flutter/material.dart';
import 'package:king_investor/domain/value_objects/performance.dart';
import 'package:king_investor/presentation/pages/evolution/widgets/evolution_row.dart';
import 'package:king_investor/presentation/widgets/custom_expansion_tile_widget.dart';

class EvolutionCard extends StatelessWidget {
  final Performance result;
  final String? resultTitle;
  final bool initiallyExpanded;

  EvolutionCard({required this.result, required this.resultTitle, this.initiallyExpanded: false});

  @override
  Widget build(BuildContext context) {
    final totalPorcentage = result.totalResultPorcentage.toPorcentage();
    final totalValue = result.totalResultValue.toMonetary("BRL");
    final style = TextStyle(fontSize: 21, fontWeight: FontWeight.bold);
    return CustomExpansionTileWidget(
      initiallyExpanded: initiallyExpanded,
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      childrenPadding: EdgeInsets.fromLTRB(20, 0, 20, 2),
      title: Text(resultTitle ?? '?', style: style),
      children: [
        EvolutionRow('Total na carteira', result.totalInWallet.toMonetary("BRL")),
        EvolutionRow('Total Investido', result.totalInvested.toMonetary("BRL")),
        EvolutionRow('Proventos', result.totalIncomes.toMonetary("BRL"), color: true),
        EvolutionRow('Vendas', result.totalSales.toMonetary("BRL"), color: true),
        EvolutionRow('Valorização', result.assetsValorization.toMonetary("BRL"), color: true),
        EvolutionRow('Resultado', totalValue, complement: totalPorcentage),
        SizedBox(height: 4),
      ],
    );
  }
}
