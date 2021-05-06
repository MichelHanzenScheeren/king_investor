import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/dependencies_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependenciesInjection.init(Environments.development);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'King Investor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  void _test() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _test,
      ),
    );
  }
}
