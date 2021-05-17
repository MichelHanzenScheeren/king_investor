import 'package:flutter/material.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/presentation/widgets/custom_divider_widget.dart';
import 'package:king_investor/presentation/widgets/custom_flex_text.dart';
import 'package:king_investor/shared/extensions/string_extension.dart';

class AboutCompany extends StatelessWidget {
  final Company company;

  AboutCompany(this.company);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CustomFlexText(
          texts: ['${company.name} (${company.symbol})'],
          size: 20,
          showDivider: false,
          weight: FontWeight.bold,
        ),
        SizedBox(height: 6),
        CustomDividerWidget(
          text: 'Sobre a companhia',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          dividerColor: theme.hintColor,
        ),
        CustomFlexText(
          texts: ['Região', company?.region?.firstToUpper()],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['País', '${company?.country} (${company?.currency})'],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Bolsa negociada', company?.exchange],
          alignment: MainAxisAlignment.spaceBetween,
        ),
      ],
    );
  }
}
