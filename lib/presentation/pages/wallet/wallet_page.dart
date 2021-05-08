import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/presentation/controllers/load_data_controller.dart';
import 'package:king_investor/presentation/controllers/wallet_controller.dart';
import 'package:king_investor/presentation/widgets/load_indicator_widget.dart';

class WalletPage extends StatelessWidget {
  final walletController = WalletController();
  final LoadDataController loadController = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        SizedBox(height: 5),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(Icons.account_balance_wallet),
                SizedBox(width: 10),
                Obx(() {
                  if (loadController.walletsLoad) return awaiting();
                  Wallet current = walletController.getCurrentWallet();
                  return Expanded(
                    child: Text(
                      current?.name ?? "",
                      style: theme.textTheme.headline1.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
                SizedBox(width: 10),
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
            ),
          ),
        ),
        Divider(
          color: theme.textSelectionTheme.selectionColor,
          height: 10,
          endIndent: 10,
          indent: 10,
        ),
      ],
    );
  }

  Widget awaiting() {
    return Expanded(
      child: Row(
        children: <Widget>[
          LoadIndicatorWidget(),
          Expanded(child: Text("")),
        ],
      ),
    );
  }
}
