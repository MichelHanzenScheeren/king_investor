import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/search_controller.dart';
import 'package:king_investor/presentation/pages/search/widgets/list_of_results.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/custom_text_field_widget.dart';
import 'package:king_investor/presentation/widgets/load_indicator_widget.dart';

class SearchPage extends StatelessWidget {
  final searchController = SearchController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Container(
          color: Colors.black87,
          height: double.maxFinite,
          width: double.maxFinite,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).accentColor,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 15),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Get.back(),
                      ),
                      Expanded(
                        child: CustomTextFieldWidget(
                          placeHolder: "Nome ou código do ativo",
                          borderRadius: 15,
                          onSubmit: searchController.search,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Obx(() {
                  if (searchController.load) return _load();
                  if (searchController.companies.isEmpty) return _empty(theme);
                  return ListOfResults(searchController, scrollController);
                }),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
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
