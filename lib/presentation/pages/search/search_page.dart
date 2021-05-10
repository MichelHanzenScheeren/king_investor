import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/search_controller.dart';
import 'package:king_investor/presentation/pages/search/widgets/list_of_results.dart';
import 'package:king_investor/presentation/widgets/custom_text_field_widget.dart';

class SearchPage extends StatelessWidget {
  final searchController = SearchController();

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
                ListOfResults(searchController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
