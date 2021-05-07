import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/dependencies_injection.dart';
import 'package:king_investor/presentation/pages/load/load_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependenciesInjection.init(Environments.development);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'King Investor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.white,
      ),
      home: LoadPage(),
    );
  }
}
