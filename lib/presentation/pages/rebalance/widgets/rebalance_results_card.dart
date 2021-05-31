import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/rebalance_result.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/rebalance_controller.dart';
import 'package:king_investor/presentation/widgets/custom_button_widget.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/custom_dialog_widget.dart';
import 'package:king_investor/presentation/widgets/load_indicator_widget.dart';

class RebalanceResultsCard extends StatelessWidget {
  final RebalanceController rebalanceController;
  final AppDataController appDataController = Get.find();

  RebalanceResultsCard(this.rebalanceController);

  @override
  Widget build(BuildContext context) {
    final rebalanceResult = rebalanceController.rebalanceResult!;
    final totalValue = Amount(rebalanceController.aportValue.value - rebalanceResult.totalValue.value);
    final theme = Theme.of(context);
    final title = TextStyle(color: theme.hintColor, fontSize: 18, fontWeight: FontWeight.w900);
    final subtitle = title.copyWith(fontSize: 18, fontWeight: FontWeight.w700);
    final item = TextStyle(color: theme.hintColor, fontSize: 16);
    return CustomCardWidget(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      children: [
        Text('Rebalanceamento da Carteira "${appDataController.currentWallet?.name}"', style: title),
        SizedBox(height: 25),
        Container(child: Text('Dados:', style: subtitle), alignment: Alignment.centerLeft),
        SizedBox(height: 8),
        _itemText('Valor do aporte:', '${rebalanceController.aportValue.toMonetary("BRL")}', item),
        _itemText('Máximo de ativos:', '${rebalanceController.assetsMaxNumber.value}', item),
        _itemText('Máximo de categorias:', '${rebalanceController.categoriesMaxNumber.value}', item),
        SizedBox(height: 25),
        Container(child: Text('Sugestão de Rebalanceamento:', style: subtitle), alignment: Alignment.centerLeft),
        _resultsListTile(rebalanceResult, theme),
        SizedBox(height: 25),
        Container(
          child: Text('Valor Total: ${rebalanceResult.totalValue.toMonetary("BRL")}', style: subtitle),
          alignment: Alignment.centerLeft,
        ),
        SizedBox(height: 6),
        Container(
          child: Text('Disponível: ${totalValue.toMonetary("BRL")}', style: subtitle),
          alignment: Alignment.centerLeft,
        ),
        SizedBox(height: 30),
        Obx(() {
          if (rebalanceController.savingRebalanceResults) return LoadIndicatorWidget();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButtonWidget(
                width: MediaQuery.of(context).size.width * (rebalanceResult.items.isEmpty ? 0.8 : 0.4),
                backGroundColor: Colors.transparent,
                buttonText: 'VOLTAR',
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.primaryColor),
                onPressed: () => rebalanceController.clearResults(),
              ),
              rebalanceResult.items.isEmpty ? Container() : Expanded(child: Text('')),
              rebalanceResult.items.isEmpty
                  ? Container()
                  : CustomButtonWidget(
                      width: MediaQuery.of(context).size.width * 0.4,
                      backGroundColor: theme.primaryColor,
                      buttonText: 'APLICAR',
                      textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.hintColor),
                      onPressed: rebalanceResult.items.isEmpty ? null : _saveRebalance,
                    ),
            ],
          );
        }),
      ],
    );
  }

  Widget _resultsListTile(RebalanceResult rebalanceResult, ThemeData theme) {
    final resultStyle = TextStyle(color: theme.hintColor, fontSize: 17, fontWeight: FontWeight.w600);
    final resultLegendStyle = TextStyle(color: theme.hintColor, fontSize: 15);
    if (rebalanceResult.items.length == 0) {
      String mesage = 'Com base na distrubuição atual da carteira e o valor do aporte, sugerimos aguardar um pouco ';
      mesage += '  para continuar aportando...';
      return ListTile(
        contentPadding: EdgeInsets.fromLTRB(12, 4, 8, 4),
        dense: true,
        title: Text(mesage, style: resultStyle, textAlign: TextAlign.justify),
      );
    }
    return Column(
      children: List<Widget>.generate(rebalanceResult.items.length, (index) {
        final result = rebalanceResult.items[index];
        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(12, 4, 8, 4),
              dense: true,
              title: Text('${result.quantity.value}un. de ${result.symbol}', style: resultStyle),
              subtitle: Text('Preço: ${result.price.toMonetary("BRL")}', style: resultLegendStyle),
              trailing: Text('Subtotal: ${result.total.toMonetary("BRL")}', style: resultLegendStyle),
            ),
            Divider(color: theme.primaryColorLight, height: 4),
          ],
        );
      }),
    );
  }

  Widget _itemText(String text, String value, TextStyle style) {
    return Row(
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.only(left: 12, bottom: 2),
            child: Text('$text  $value', style: style),
            alignment: Alignment.centerLeft,
          ),
        ),
      ],
    );
  }

  void _saveRebalance() {
    Get.dialog(CustomDialogWidget(
      title: 'Tem certeza que deseja aplicar o rebalanceamento?',
      textContent: '    As quantidades serão incrementadas aos ativos correspondentes e o preço médio ' +
          'recalculado com base no preço atual do ativo.',
      confirmButtonText: 'APLICAR',
      accentColor: Theme.of(Get.context!).primaryColor,
      textContentColor: Theme.of(Get.context!).hintColor,
      onConfirm: () {
        Get.back();
        rebalanceController.saveRebalance();
      },
    ));
  }
}
