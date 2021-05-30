import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/rebalance_controller.dart';
import 'package:king_investor/presentation/pages/rebalance/widgets/edit_category_score.dart';
import 'package:king_investor/presentation/widgets/custom_expansion_tile_widget.dart';

class CategoryScoresExpansionTile extends StatelessWidget {
  final RebalanceController rebalanceController;

  CategoryScoresExpansionTile(this.rebalanceController);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final categoryScores = rebalanceController.getActiveCategoryScores();
      return CustomExpansionTileWidget(
        title: Text('Notas das categorias', style: TextStyle(fontSize: 20)),
        children: List<Widget>.generate(categoryScores.length, (index) {
          final categoryScore = categoryScores[index];
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(12, 2, 12, 2),
                visualDensity: VisualDensity(vertical: -1),
                dense: true,
                title: Container(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    categoryScore.category.name,
                    style: TextStyle(color: theme.hintColor, fontSize: 16),
                  ),
                ),
                subtitle: Text(
                  'Nota: ${categoryScore.score.value}',
                  style: TextStyle(color: theme.primaryColorLight, fontSize: 14),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit, color: theme.hintColor),
                  onPressed: () => Get.bottomSheet(EditCategoryScore(categoryScore, rebalanceController)),
                ),
              ),
              Divider(color: theme.primaryColorLight, height: 2),
            ],
          );
        }),
      );
    });
  }
}
