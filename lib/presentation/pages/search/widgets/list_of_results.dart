import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/search_controller.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/load_indicator_widget.dart';

class ListOfResults extends StatelessWidget {
  final SearchController searchController;

  ListOfResults(this.searchController);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      if (searchController.load) return _load();
      if (searchController.companies.isEmpty) return _empty(theme);
      final companies = searchController.companies;
      final title = TextStyle(fontSize: 18, color: theme.hintColor, fontWeight: FontWeight.bold);
      final normal = TextStyle(fontSize: 14, color: theme.primaryColorLight);
      return ListView.builder(
        itemCount: companies.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
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
                  companies[index]?.name ?? '?',
                  style: TextStyle(color: theme.primaryColorLight, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.add, color: theme.hintColor),
                  onPressed: () {},
                ),
              )
            ],
          );
        },
      );
    });
  }

  Widget _load() {
    return Container(
      width: double.maxFinite,
      child: CustomCardWidget(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: [
          LoadIndicatorWidget(size: 120, usePrimaryColor: false),
        ],
      ),
    );
  }

  Widget _empty(ThemeData theme) {
    return Container(
      width: double.maxFinite,
      child: CustomCardWidget(
        children: [
          Icon(Icons.search, size: 120, color: theme.hintColor),
          SizedBox(height: 20),
          Text(
            'Por enquanto tudo calmo por aqui...',
            style: TextStyle(color: theme.hintColor, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
