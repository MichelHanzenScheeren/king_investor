import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/value_objects/performance.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/evolution_controller.dart';
import 'package:king_investor/presentation/controllers/filter_controller.dart';
import 'package:king_investor/presentation/pages/evolution/widgets/empty_evolution_card.dart';
import 'package:king_investor/presentation/pages/evolution/widgets/evolution_card.dart';
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
                prefixText: 'Filtrar por',
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
                prefixText: 'Ordem',
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
          if (appDataController.isLoadingSomething || appDataController.assets.isEmpty) return Container();
          final List<Performance> results = <Performance>[];
          if (evolutionController.selectedFilter == SelectedFilter.categories) {
            final categories = appDataController.usedCategories;
            categories.forEach((cat) => results.add(evolutionController.categoryPerformance(cat)));
          } else {
            appDataController.assets.forEach((asset) => results.add(evolutionController.assetPerformance(asset)));
          }
          evolutionController.applySort(results, evolutionController.selectedOrder);
          return Column(
            children: results.map((e) => EvolutionCard(resultTitle: e.identifier, result: e)).toList(),
          );
        }),
        SizedBox(height: 4),
      ],
    );
  }
}
