import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/value_objects/performance.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/evolution_controller.dart';
import 'package:king_investor/presentation/pages/evolution/widgets/empty_evolution_card.dart';
import 'package:king_investor/presentation/pages/evolution/widgets/evolution_card.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/custom_dropdown_widget.dart';
import 'package:king_investor/presentation/widgets/load_card_widget.dart';

class EvolutionPage extends StatelessWidget {
  final EvolutionController evolutionController = EvolutionController();
  final AppDataController appDataController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetX<EvolutionController>(
      init: evolutionController,
      builder: (evolutionController) {
        if (appDataController.isLoadingSomething) return LoadCardWidget();
        if (appDataController.isMissingData) return EmptyEvolutionCard();
        return Column(
          children: [
            SizedBox(height: 4),
            EvolutionCard(
              resultTitle: 'Desempenho Geral',
              result: evolutionController.getGeneralPerformance(),
              initiallyExpanded: true,
            ),
            GetX<EvolutionController>(
              builder: (evolutionController) {
                return CustomCardWidget(
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                  children: [
                    CustomDropdownWidget<SelectedFilter>(
                      prefixText: 'Filtrar por',
                      initialValue: evolutionController.selectedFilter,
                      onChanged: (item) => evolutionController.setSelectedFilter(item!),
                      values: _filterDropdownValues(),
                    ),
                    SizedBox(height: 12),
                    CustomDropdownWidget<SelectedOrder>(
                      prefixText: 'Ordenar por',
                      initialValue: evolutionController.selectedOrder,
                      onChanged: (item) => evolutionController.setSelectedOrder(item!),
                      values: _orderDropdownValues(),
                    ),
                  ],
                );
              },
            ),
            GetX<EvolutionController>(builder: (evolutionController) {
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
            SizedBox(height: 8),
          ],
        );
      },
    );
  }

  List<CustomDropdownItems<SelectedFilter>> _filterDropdownValues() {
    final map = SelectedFilter.values.map(
      (filter) => CustomDropdownItems(filter, evolutionController.filterDescription(filter)),
    );
    return map.toList();
  }

  List<CustomDropdownItems<SelectedOrder>> _orderDropdownValues() {
    final map = SelectedOrder.values.map(
      (order) => CustomDropdownItems(order, evolutionController.orderDescription(order)),
    );
    return map.toList();
  }
}
