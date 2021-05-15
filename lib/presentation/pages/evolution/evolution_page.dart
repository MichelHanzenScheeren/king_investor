import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/evolution_controller.dart';
import 'package:king_investor/presentation/controllers/filter_controller.dart';
import 'package:king_investor/presentation/pages/evolution/widgets/empty_evolution_card.dart';
import 'package:king_investor/presentation/pages/evolution/widgets/evolution_row.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/custom_dropdown_widget.dart';
import 'package:king_investor/presentation/widgets/custom_expansion_tile_widget.dart';
import 'package:king_investor/presentation/widgets/load_card_widget.dart';

class EvolutionPage extends StatelessWidget {
  final filterController = FilterController();
  final EvolutionController evolutionController = EvolutionController();
  final AppDataController appDataController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 4),
        Obx(() {
          if (appDataController.isLoadingSomething) return LoadCardWidget();
          if (appDataController.assets.isEmpty) return EmptyEvolutionCard();
          final result = evolutionController.getGeneralPerformance();
          final titleStyle = TextStyle(color: Theme.of(context).hintColor, fontSize: 20, fontWeight: FontWeight.bold);
          final totalPorcentage = result.totalResultPorcentage.toPorcentage();
          return CustomCardWidget(
            padding: const EdgeInsets.all(14),
            children: [
              Text('Desempenho Geral', style: titleStyle),
              SizedBox(height: 12),
              EvolutionRow('Total em carteira', result.totalInWallet.toMonetary("BRL")),
              EvolutionRow('Total Investido', result.totalInvested.toMonetary("BRL")),
              EvolutionRow('Proventos', result.totalIncomes.toMonetary("BRL"), color: true),
              EvolutionRow('Vendas', result.totalSales.toMonetary("BRL"), color: true),
              EvolutionRow('Valorização', result.assetsValorization.toMonetary("BRL"), color: true),
              EvolutionRow('Resultado', result.totalResultValue.toMonetary("BRL"), complement: totalPorcentage),
            ],
          );
        }),
        Obx(() {
          if (appDataController.isLoadingSomething || appDataController.assets.isEmpty) return Container();
          return CustomCardWidget(
            margin: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            children: [
              CustomDropdownWidget<SelectedFilter>(
                initialValue: evolutionController.selectedFilter,
                onChanged: evolutionController.setSelectedFilter,
                values: SelectedFilter.values.map(
                  (filter) {
                    return CustomDropdownItems(filter, evolutionController.filterDescription(filter));
                  },
                ).toList(),
              ),
              SizedBox(height: 12),
              CustomDropdownWidget<SelectedOrder>(
                initialValue: evolutionController.selectedOrder,
                onChanged: evolutionController.setSelectedOrder,
                values: SelectedOrder.values.map(
                  (order) {
                    return CustomDropdownItems(order, evolutionController.orderDescription(order));
                  },
                ).toList(),
              ),
            ],
          );
        }),
        Obx(() {
          if (appDataController.isLoadingSomething) return LoadCardWidget();
          return Column(
            children: appDataController.usedCategories.map((cat) {
              final style = TextStyle(color: Theme.of(context).hintColor, fontSize: 20, fontWeight: FontWeight.bold);
              final result = evolutionController.getCategoryPerformance(cat);
              final totalPorcentage = result.totalResultPorcentage.toPorcentage();
              final totalValue = result.totalResultValue.toMonetary("BRL");
              return CustomExpansionTileWidget(
                margin: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                childrenPadding: EdgeInsets.fromLTRB(20, 0, 20, 8),
                title: Text(cat.name, style: style),
                children: [
                  Text('Desempenho', style: style.copyWith(fontSize: 18)),
                  SizedBox(height: 12),
                  EvolutionRow('Total na carteira', result.totalInWallet.toMonetary("BRL"), factor: 0.9),
                  EvolutionRow('Total Investido', result.totalInvested.toMonetary("BRL"), factor: 0.9),
                  EvolutionRow('Proventos', result.totalIncomes.toMonetary("BRL"), color: true, factor: 0.9),
                  EvolutionRow('Vendas', result.totalSales.toMonetary("BRL"), color: true, factor: 0.9),
                  EvolutionRow('Valorização', result.assetsValorization.toMonetary("BRL"), color: true, factor: 0.9),
                  EvolutionRow('Resultado', totalValue, complement: totalPorcentage, factor: 0.9),
                ],
              );
            }).toList(),
          );
        }),
        SizedBox(height: 4),
      ],
    );
  }
}
