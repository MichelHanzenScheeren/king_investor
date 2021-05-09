import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/load_data_controller.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/load_indicator_widget.dart';

class WalletsTopCard extends StatelessWidget {
  final LoadDataController loadController;

  WalletsTopCard({@required this.loadController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomCardWidget(
      direction: Axis.horizontal,
      children: <Widget>[
        Icon(Icons.account_balance_wallet),
        SizedBox(width: 15),
        Obx(() {
          if (loadController.walletsLoad) return _awaiting();
          return Expanded(
            child: Text(
              loadController.currentWallet?.name ?? "",
              style: TextStyle(
                color: theme.primaryColorLight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }),
        SizedBox(width: 15),
        GestureDetector(
          child: Icon(Icons.edit, size: 28),
          onTap: () => showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) => Container(),
          ),
        ),
      ],
    );
  }

  Widget _awaiting() {
    return Expanded(
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 10),
            child: LoadIndicatorWidget(size: 20, strokeWidth: 2, usePrimaryColor: false),
          ),
          Expanded(child: Text("")),
        ],
      ),
    );
  }
}
