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
    final double width = 0.4 * (size.width < size.height ? size.width : size.height);
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        child: AnimatedBuilder(
          animation: controller.control,
          builder: (context, child) {
            final control = controller.control;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
                    width: width * control.value,
                    child: Image(image: AssetImage(AppImages.transparentLogo), fit: BoxFit.fill),
                  ),
                ),
                Container(
                  height: 25 * control.value,
                  child: Text('KING INVESTOR', style: TextStyle(color: theme.hintColor, fontSize: 26)),
                ),
                SizedBox(height: 50),
                Container(
                    height: 50,
                    child: control.value != 1.0 ? Container() : LoadIndicatorWidget(color: theme.hintColor)),
              ],
            );
          },
        ),
      ),
    );
  }
}
