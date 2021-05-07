import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:king_investor/presentation/controllers/splash_controller.dart';
import 'package:king_investor/presentation/static/app_images.dart';
import 'package:king_investor/presentation/widgets/load_indicator_widget.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  final controller = SplashController();

  @override
  void initState() {
    super.initState();
    controller.control = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    controller.curve = CurvedAnimation(parent: controller.control, curve: Curves.easeInOutExpo);
    controller.initialConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = 0.5 * (size.width < size.height ? size.width : size.height);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: AnimatedBuilder(
          animation: controller.control,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                    width: width * controller.control.value,
                    child: Image(image: AssetImage(AppImages.transparentLogo), fit: BoxFit.fill),
                  ),
                ),
                Container(
                  height: 25 * controller.control.value,
                  child: Text('KING INVESTOR', style: TextStyle(color: Theme.of(context).accentColor, fontSize: 26)),
                ),
                SizedBox(height: 50),
                Container(height: 50, child: controller.control.value != 1.0 ? Container() : LoadIndicatorWidget()),
              ],
            );
          },
        ),
      ),
    );
  }
}
