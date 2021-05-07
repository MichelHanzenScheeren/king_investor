import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.logout, color: Colors.deepPurple, size: 50),
              onPressed: () => Get.find<UserUseCase>().logout(),
            ),
          ],
        ),
      ),
    );
  }
}
