import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/presentation/controllers/search_controller.dart';
import 'package:king_investor/presentation/pages/search/widgets/save_asset_form.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/load_indicator_widget.dart';

class ListOfResults extends StatelessWidget {
  final SearchController searchController;
  final ScrollController scrollController;

  ListOfResults(this.searchController, this.scrollController);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final companies = searchController.companies;
    final title = TextStyle(fontSize: 18, color: theme.hintColor, fontWeight: FontWeight.bold);
    final normal = TextStyle(fontSize: 14, color: theme.primaryColorLight);
    return ListView.builder(
      controller: scrollController,
      itemCount: companies.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Obx(() {
          final company = companies[index];
          return CustomCardWidget(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            children: [
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                dense: true,
                title: RichText(
                  text: TextSpan(
                    text: company.symbol + '   ',
                    style: title,
                    children: [TextSpan(text: "${company.exchange} - ${company.country}", style: normal)],
                  ),
                ),
                subtitle: Text(
                  company?.name ?? '?',
                  style: TextStyle(color: theme.primaryColorLight, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: _getTrailing(company, theme),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _getTrailing(Company company, ThemeData theme) {
    if (searchController.save && company.objectId == searchController.saveId) return LoadIndicatorWidget();
    if (searchController.isSavedAsset(company?.ticker))
      return IconButton(icon: Icon(Icons.check), disabledColor: theme.hintColor, onPressed: null);
    return IconButton(
      icon: Icon(Icons.add, color: theme.hintColor),
      onPressed: searchController.save ? null : () => _trySave(company),
    );
  }

  void _trySave(Company company) {
    Get.bottomSheet(
      SaveAssetForm(company: company, searchController: searchController),
      isDismissible: false,
      isScrollControlled: true,
    );
  }
}
