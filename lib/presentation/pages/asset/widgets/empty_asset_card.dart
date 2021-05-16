import 'package:flutter/material.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';

class EmptyAssetCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = TextStyle(color: Theme.of(context).hintColor, fontSize: 22);
    return ListView(
      children: [
        SizedBox(height: 4),
        CustomCardWidget(
          children: [
            SizedBox(height: 25),
            Text(
              'Poxa, isso é confuso...',
              style: textTheme,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Icon(
              Icons.warning,
              size: 180,
            ),
            SizedBox(height: 20),
            Text(
              'O ativo não pode ser encontrado...\nTente novamente mais tarde.',
              style: textTheme.copyWith(fontSize: 20, height: 1.5),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),
          ],
        ),
      ],
    );
  }
}
