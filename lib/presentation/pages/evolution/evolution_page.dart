import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/evolution_controller.dart';
import 'package:king_investor/presentation/controllers/filter_controller.dart';
import 'package:king_investor/presentation/pages/evolution/widgets/evolution_row.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/load_card_widget.dart';

class EvolutionPage extends StatelessWidget {
  final filterController = FilterController();
  final EvolutionController evolutionController = EvolutionController();
  final AppDataController appDataController = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      children: [
        SizedBox(height: 4),
        Obx(() {
          if (appDataController.isLoadingSomething) return LoadCardWidget();
          final result = evolutionController.getGeneralPerformance();
          return CustomCardWidget(
            children: [
              Text(
                'Desempenho Geral',
                style: TextStyle(color: theme.hintColor, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              EvolutionRow('Total em carteira', result.totalInWallet.toMonetary("BRL")),
              EvolutionRow('Total Investido', result.totalInvested.toMonetary("BRL")),
              EvolutionRow('Proventos', result.totalIncomes.toMonetary("BRL"), color: true),
              EvolutionRow('Vendas', result.totalSales.toMonetary("BRL"), color: true),
              EvolutionRow('Valorização dos ativos', result.assetsValorization.toMonetary("BRL"), color: true),
              EvolutionRow(
                'Resultado',
                result.totalResultValue.toMonetary("BRL"),
                color: true,
                complement: result.totalResultPorcentage.toPorcentage(),
              ),
            ],
          );
        }),
        // CustomCardWidget(
        //   children: [
        //     SizedBox(height: 4),
        //     CustomFilterCardWidget(filterController),
        //     SizedBox(height: 4),
        //   ],
        // )
      ],
    );
  }
}
