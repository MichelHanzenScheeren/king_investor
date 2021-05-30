import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/category_score.dart';
import 'package:king_investor/domain/value_objects/score.dart';
import 'package:king_investor/presentation/controllers/rebalance_controller.dart';
import 'package:king_investor/presentation/widgets/custom_bottom_sheet_widget.dart';
import 'package:king_investor/presentation/widgets/custom_text_field_widget.dart';

class EditCategoryScore extends StatelessWidget {
  final CategoryScore categoryScore;
  final RebalanceController rebalanceController;
  final Score score = Score(10);

  EditCategoryScore(this.categoryScore, this.rebalanceController) {
    score.setValue(categoryScore.score.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      child: Builder(
        builder: (context) {
          return CustomBottomSheetWidget(
            children: [
              SizedBox(height: 15),
              Flexible(
                child: Text(
                  'Nota da categoria "${categoryScore.category.name}"',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: theme.hintColor),
                ),
              ),
              SizedBox(height: 20),
              CustomTextFieldWidget(
                autoFocus: true,
                textInputType: TextInputType.number,
                placeHolder: "Nota",
                initialValue: '${score.value}',
                onChanged: (value) => score.setValueFromString(value),
                validator: (value) => score.isValid ? null : score.notifications.first.message,
                onSubmit: (value) {
                  if (!Form.of(context)!.validate()) return;
                  Get.back();
                  categoryScore.score.setValue(score.value);
                  rebalanceController.updateCategoryScore(categoryScore);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
