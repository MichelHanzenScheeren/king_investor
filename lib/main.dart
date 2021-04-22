import 'package:flutter/material.dart';
// import 'package:king_investor/static/keys.dart';
// import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Parse().initialize(kAppId, kServerUrl, clientKey: kClientKey, autoSendSessionId: true, debug: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'King Investor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
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
