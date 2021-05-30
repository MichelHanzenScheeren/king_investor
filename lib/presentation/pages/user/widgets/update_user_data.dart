import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/widgets/custom_bottom_sheet_widget.dart';
import 'package:king_investor/presentation/widgets/custom_text_field_widget.dart';

class UpdateUserData extends StatelessWidget {
  final String prefixText;
  final String? value;
  final Function(String)? onChange;
  final String? Function(String?)? validate;
  final Function? onSubmit;

  UpdateUserData({this.prefixText: '', this.value: '', this.onChange, this.validate, this.onSubmit});

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
                  'Editar $prefixText do usuário',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: theme.hintColor),
                ),
              ),
              SizedBox(height: 20),
              CustomTextFieldWidget(
                autoFocus: true,
                initialValue: value,
                onChanged: onChange,
                validator: validate,
                onSubmit: (value) {
                  if (!Form.of(context)!.validate()) return;
                  Get.back();
                  onSubmit!();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
