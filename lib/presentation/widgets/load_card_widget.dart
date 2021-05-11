import 'package:flutter/material.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/load_indicator_widget.dart';

class LoadCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomCardWidget(
      children: [
        Container(
          height: size.height * 0.4,
          alignment: Alignment.center,
          child: LoadIndicatorWidget(usePrimaryColor: false, size: 120),
        ),
      ],
    );
  }
}
